Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADF64F9136
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiDHIzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 04:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbiDHIy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 04:54:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD37336AE43;
        Fri,  8 Apr 2022 01:52:52 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23862FTN006418;
        Fri, 8 Apr 2022 08:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ICIHjUHESQ81K4s9i/RlgwUlE21S8v2ZUMkxnvarYrU=;
 b=WatH4e/Qe9vAXOs/isQWPBh5i/xarsMnj4ntKSyI0Z7j6O5sJUU9fXr5j7lddpwJetec
 sT3BvqAAV2oplgV5zUMZ4hNL3TwBoGAEalxW8jFK6btbtMJgfNQRWxH/2H6pZOc7szlx
 AbMAvHPozLKPdGjzmilM1AZThqnSbX7ohBnFjJSr5vadk0Y6b6NhSx+qO4aZ8wHLnZLw
 ZAUc6qjrKMMoA+FgX9kz3RqWSSWmiRABdRYol/tklPCRwHZizq/BMkZRwJCEm2jxiaHY
 ZsfG2VGJvh0Rx3Zl+03u/5D8iLCsxRJKM3mkWCbbzue0XjrEI44rz+E1PzhUrgbh2T6t /A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31ph0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 08:52:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2387S2dH029005;
        Fri, 8 Apr 2022 08:52:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974f2nxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 08:52:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faLtd1yu71hvAvXFo1ZkjaLNk9aRbp6VVB5hX20Z3vBUY5mftB3z7RPpwYk0wG4FcvVtOOmaTQMmAFg/8TuyU/RnawVBM/An9Yvvm+DyYp2Bd9ucjwLb8sBMSrzX17ON9CgYfilX9DX2a598W808O7n89VATPFXSOnmQJnJeRHY7OtoonR5Funl9cGPXNV0364888iEuqkfdcX5NGgToZ330GutEFEImkIqhGWGWVb1wEvCQPQWfx3/XCCuQ71Zj97UJW2AO0gSHYOjk9zuHYcq4fuhUfkIJwLkm8SbOQby/Rszb4mnc44IHiKhn3oUn0u7/NO3SPDPh8RpCcqgClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICIHjUHESQ81K4s9i/RlgwUlE21S8v2ZUMkxnvarYrU=;
 b=ExWO5wsicPOQQW2Nb0Nnmf4s8wn5p9qArC85l196LTHmeKzf/rShbLn0gd14WTJDo4pGBecymaXt3rKCN8cpbU0Emqc+K/Kpt3kMhUlIkKCi0zbe2LAYsx9kc2UUDeL1p+wibyqxnMhBEkUqEdgGshDqYGGvXGn6SFOG/Ozu6UI3ebuOVLG0IkYk98NiobKAALrMyVI9rW77PXU/oh0qzhkQJNz5gPbtaMcrZmfi5ErQ92Fy5T5o+Fl0zQZxwGThuRXXeEjmP6nuBbgF4NA/lquea04bpDOgTWgw6Mai31yzLTMZN3+84AwyhyHJz6qHUkl9WRmGh7GxHXYiWbsp5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICIHjUHESQ81K4s9i/RlgwUlE21S8v2ZUMkxnvarYrU=;
 b=o0frSTP2S8xACVXBqWN55eZ77nCbTtw8j6Rs5Af6nyT2BMHgCi9hwApZ56YcTzSBi0O+C9R2MrOoJnFIzwUXGMRHiVeGJNR1MFKq3hmO8w5mLYcGGAYneEYvrhNQVaBmYoN7S7JFJC6JZcL9DEjTboDUl83qCKuXDt89hxuJYXM=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by MWHPR10MB1808.namprd10.prod.outlook.com (2603:10b6:300:10a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 08:52:17 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::d03a:5c0e:309:7eac]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::d03a:5c0e:309:7eac%8]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 08:52:17 +0000
Message-ID: <0813c9da-f91d-317e-2eda-f2ed0b95385f@oracle.com>
Date:   Fri, 8 Apr 2022 10:52:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Content-Language: en-US
To:     Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <91dd5f0a-61da-074d-42ed-bf0886f617d9@oracle.com>
 <a37bb4b7-3772-4579-a4e6-d27fb29411a6@google.com>
 <c3131f1c-a354-ca3b-ed61-5b06ef1ab7a1@oracle.com>
 <a23e32d3-9738-278b-42d3-5fe45cfab721@google.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
In-Reply-To: <a23e32d3-9738-278b-42d3-5fe45cfab721@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0167.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::35) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66de2f6e-5d13-42b8-0011-08da193d1571
X-MS-TrafficTypeDiagnostic: MWHPR10MB1808:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB18081F4747065ADAE2F56A349AE99@MWHPR10MB1808.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wuFxBn5w0lFWzLyVwGHXs/RR3MY6mtdolvAxKz0HonprhAk7lt6HRycm6i98cRXd5IX4s89eGo3OqhVRFvKD2Om2X1n6MeqTIEYzHnqPBomhmMixybsrACa8dkmcPKj9F7H8ihLUo5ym064+NNd9+UPPS6BHMx+iLQ+sQW4PC8lnhmu87PUJOBFOoBo38JgBWzP3ejmbHbNBnTQ2U9E2Yl5Yz15axKfQkiGvb4WhET4ZnLM+t04bQubAfRnN0sfdj4KC20Aafm4MA8g4rU8rIsevwYmVIz3Kv0KGHpEzU2sST+0EVI1ECEw4Oq8nXclMNvoWbhsVbDv8p7vWt5dsXGjVTgxoqtvOC4lV04ysHFzsBS6RXyFpLatfekpFtAZrCe9fUUpmEQTRRqOWStdIOZw2EaCSPXu3bd5zbL+9x1tQ9G7/juwRMdjwrA1KZckbYTqYlIBPxBLgo0EOKeUYsruwAoPphwNFUuyJgHczcmNrO/0FYizlGU2xWtJ/eJTnSCyYy5h5GogjSWZGYKzBHns10F+ja4VNzA1QenUiHRj8fQc/qmLmRd9GFSW8T/LfYpYflwjcFRIq8II6e2E4w7/dS8qWHYCs5QRbXG6UDHlfFQFrtSDzoru8IxMC5T+BhX5geWjXUN6IDdMn/8KeqjhUU6VeOOzaF5AQNG7OfGxCVROEytkcYAoL0b5732+aF5uphZUJXWYajuKk78rjB7KWCbU/YWG8/qcmatYuTU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(66946007)(4326008)(8676002)(31696002)(5660300002)(86362001)(6486002)(53546011)(508600001)(83380400001)(6666004)(44832011)(38100700002)(6506007)(7416002)(8936002)(2906002)(31686004)(2616005)(26005)(316002)(186003)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWpqb09GMDhCOFFsMndDSHRYQWpnRXlMcy9QZWJLcHdTd043TTJwMDhSS3Vp?=
 =?utf-8?B?NTdtcGZvVzN5ckdNMjFQSldzWWRJWDVxQmtndDdRWjhzc0hIb2ptdHZlamtK?=
 =?utf-8?B?a09sbXQ1N3kycS80cGZrQVZGL0drNkhhK1dZTWIzYkZKZXQzSG1QM2FIbEdK?=
 =?utf-8?B?QUIxa085VUdLVWVoWkdQdHpRNFBzNFlocy9RTkFlUitvQzgwRTZFQlhiWEdq?=
 =?utf-8?B?cmhjYTFERWpsMHhGUlRyWmtOZnRhYzlGOGI0WG16ZzRFbVNUSmE3Y2ZvZUMx?=
 =?utf-8?B?N1pUckpieW0yd0V2aUY2SFlxS09yMUJTcVlSc2ZjTmREMWZmNlNwSS9Nd291?=
 =?utf-8?B?dkwrYjBvVm9FQ2JaQVUwWWpJYWc1WGI0TFd5L1VTNWxNQ0V4Vi8yMS9QejlG?=
 =?utf-8?B?QkpnSno2dTl2cE45WTZ5K2s4UjcxZGxTa3R0d3c5T2p3VzRVc1NiT0l6anIz?=
 =?utf-8?B?VGdNL1BjbHNta1dxbzB5VkF2Y2xPdmFBQ2M1MFB2NGtmemFLQmpMdm5UTjFz?=
 =?utf-8?B?bFE2K2oyUHg0S3FMVnBIVkhLSEpQa3hFNHZQMVRBblp1UER1WndLR2c0YmVs?=
 =?utf-8?B?NUFhZFdScmMwWmlMQkd3UzVQVDhMWU55dm1EYWlMc1dTU2Z1V1Bib3lFZGFV?=
 =?utf-8?B?eHBGaDVZbE1wcW8rYXdnbEdTbmFlRHg1YTg0L3BxZDdsRFRHSnpMc1lrRHZB?=
 =?utf-8?B?ZHV1cFdQMk9seFJlU3UxQzMyclpHMWkxRDdmdU9qRHFvYWhSYXhUL3BkTG5S?=
 =?utf-8?B?eVJscm5LN2FKbHhsM1JSYVV2eHJZZTc3MkNndVdpbnNTUks1MzA0Sjgrb2RT?=
 =?utf-8?B?Nzh4WlhyQngxU28zSDFRT2RsR3RKd1VHV2F0cGJLR3pNV1ZqUWg1RHFuTmNM?=
 =?utf-8?B?N0tWczkyQTB5MmFwOFUyeFAzeHZxTG5wdCtmMURqaWVnWEFSMmx2bWh0SEdo?=
 =?utf-8?B?VFRUVzVzeG4xRGJhb1NUVCtLSGM2TzQxc1dHdDZ4RURDNHdTZm9sejNubmRy?=
 =?utf-8?B?dFFPTzZXUThwQ01INnVpdERwVHpPNzBnQTZSVjBOeFl0UGlUdDV4UkNJdEFo?=
 =?utf-8?B?dHE2emhBUHAvcVh5NEhBM2l5MitxM2RacU9mWnhnNzd1cEhqaFNUelZ1TzBD?=
 =?utf-8?B?NDZIZTd6TE0wUlpmQ09SblhWVXdSRXRpbzVRenQ1Um5zZFZoMVJxUGhsMlhE?=
 =?utf-8?B?MVp4WWd6cU1walNZd3lGU3diRDNrblRKeWc1V2wyeWcrZ1NKQlFacExOamIw?=
 =?utf-8?B?VjRhYkpQeDM3VzN1MHlxQ1Jza3hGNU1SUFl5Uy9QK25oSVloTDUwYWZnZjZF?=
 =?utf-8?B?NmtKQ3hPbjlTSXU3RWFBRDRMckJNSjBtL3V6T2dmQ0tZbnNXT2Uyamh4Q0Fy?=
 =?utf-8?B?N1kyc2grQktUaVdOL1NVeittK3JvWGNnc2dvUHpjY3lCdlI4bmNjeDlxSGJN?=
 =?utf-8?B?b0tYV0tYc2UycU13Y2s1V0cxYmhrZnFZMzhWd2JnczNCbk5yTXVuL05Wdy9a?=
 =?utf-8?B?OXFjVmpVRzE4ZGxxcDl6SVdCdWYxMzExOHNRcmhwelBscmlTZjdzTTFTcWx0?=
 =?utf-8?B?ZjJOR09oZDdleTc4QzMrbjdOY2k0N1V2Zk5OeGw1bHFyMkJCWGd2bjNMdmVH?=
 =?utf-8?B?QW00cEpoUHdKb1liNDVHY3FNV1REdi90aWloTDgxY0lKREI4SzZ4RFFxVXd3?=
 =?utf-8?B?a1BqYlcvd0E3bTFLd2pjc1lHQXU5VW56UnI1Q1JpemFLdXdydGdwVFB4djJp?=
 =?utf-8?B?KzhhUVVWZXFiYkl6VHlnVVNCQmRid0lVVFQyVFVlTDBENDEwUndqVFVrbEdn?=
 =?utf-8?B?Q215U2l3NGVINmUzQXdXTk1PVDlWUCtGaGJPQmFtVFJzbnNpZUR1VldKVDhZ?=
 =?utf-8?B?SjhGb0VwOHA2T04xd3JsYkhFcjE0L0tOOVZnaVE4T2dqOGdaY2VWeXpQSm9I?=
 =?utf-8?B?R2Z3US9FMFhmKzkrQlQ1Q2VCTVJuUGJmdjBoSlBEQS9UVXpXSzhWaXVMS1dv?=
 =?utf-8?B?ZTZndE9rTzlwbFN1dytaMTQ3MHh6SndCSUZFM2tQTVR5VFNtcGk1ek1rQXhi?=
 =?utf-8?B?M0x5cVdwWnFUZXlTYVdwZUNHZE5STGg5aWExV0p3RGtwWG9VSjQ2bVFtWTFl?=
 =?utf-8?B?aDE0NEtqUEZ4cDNOelBvQUxGV09ELy9BMmFJd2xwWUZTOWpGU2tRVjNGNzRB?=
 =?utf-8?B?bSs5NWF0Z0MvMkh3NmdFbGFhYk1wYjFoRUpMRnVxZzNHUi9tTzdZU3didzNo?=
 =?utf-8?B?KzNIajVqN2F2RVFMazhvajR1bW9Yd0RUd2p6RUJpN0FJRkE4czg4MEhTN3Rk?=
 =?utf-8?B?R05JZ1hkYVJVOHUrMDIvbG4yK1ZYbmtPaVovL3pxZG1qVTZ4MjJPdmswR3Qz?=
 =?utf-8?Q?OF9IH7RQawn247L8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66de2f6e-5d13-42b8-0011-08da193d1571
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 08:52:17.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7yNVOVwj2VYnjI73mOq+YhBw6Bqh5LKtHjwZdrN/QVLwxRqb/L8ArC6CVgv2B7S0aDdWHNYGdVKOLuKErUFR8SYpEDXv3Kyw6Ow10uxcEKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1808
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070064
X-Proofpoint-GUID: C6ZdXS2WFhjI1sNmJbDK1HFixLHvneBv
X-Proofpoint-ORIG-GUID: C6ZdXS2WFhjI1sNmJbDK1HFixLHvneBv
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/23/22 20:35, Junaid Shahid wrote:
> On 3/22/22 02:46, Alexandre Chartre wrote:
>> 
>> On 3/18/22 00:25, Junaid Shahid wrote:
>>> 
>>> I agree that it is not secure to run one sibling in the
>>> unrestricted kernel address space while the other sibling is
>>> running in an ASI restricted address space, without doing a cache
>>> flush before re-entering the VM. However, I think that avoiding
>>> this situation does not require doing a sibling stun operation
>>> immediately after VM Exit. The way we avoid it is as follows.
>>> 
>>> First, we always use ASI in conjunction with core scheduling.
>>> This means that if HT0 is running a VCPU thread, then HT1 will be
>>> running either a VCPU thread of the same VM or the Idle thread.
>>> If it is running a VCPU thread, then if/when that thread takes a
>>> VM Exit, it will also be running in the same ASI restricted
>>> address space. For the idle thread, we have created another ASI
>>> Class, called Idle-ASI, which maps only globally non-sensitive
>>> kernel memory. The idle loop enters this ASI address space.
>>> 
>>> This means that when HT0 does a VM Exit, HT1 will either be
>>> running the guest code of a VCPU of the same VM, or it will be
>>> running kernel code in either a KVM-ASI or the Idle-ASI address
>>> space. (If HT1 is already running in the full kernel address
>>> space, that would imply that it had previously done an ASI Exit,
>>> which would have triggered a stun_sibling, which would have
>>> already caused HT0 to exit the VM and wait in the kernel).
>> 
>> Note that using core scheduling (or not) is a detail, what is
>> important is whether HT are running with ASI or not. Running core
>> scheduling will just improve chances to have all siblings run ASI
>> at the same time and so improve ASI performances.
>> 
>> 
>>> If HT1 now does an ASI Exit, that will trigger the
>>> stun_sibling() operation in its pre_asi_exit() handler, which
>>> will set the state of the core/HT0 to Stunned (and possibly send
>>> an IPI too, though that will be ignored if HT0 was already in
>>> kernel mode). Now when HT0 tries to re-enter the VM, since its
>>> state is set to Stunned, it will just wait in a loop until HT1
>>> does an unstun_sibling() operation, which it will do in its
>>> post_asi_enter handler the next time it does an ASI Enter (which
>>> would be either just before VM Enter if it was KVM-ASI, or in the
>>> next iteration of the idle loop if it was Idle-ASI). In either
>>> case, HT1's post_asi_enter() handler would also do a
>>> flush_sensitive_cpu_state operation before the unstun_sibling(), 
>>> so when HT0 gets out of its wait-loop and does a VM Enter, there
>>> will not be any sensitive state left.
>>> 
>>> One thing that probably was not clear from the patch, is that
>>> the stun state check and wait-loop is still always executed
>>> before VM Enter, even if no ASI Exit happened in that execution.
>>> 
>> 
>> So if I understand correctly, you have following sequence:
>> 
>> 0 - Initially state is set to "stunned" for all cpus (i.e. a cpu
>> should wait before VMEnter)
>> 
>> 1 - After ASI Enter: Set sibling state to "unstunned" (i.e. sibling
>> can do VMEnter)
>> 
>> 2 - Before VMEnter : wait while my state is "stunned"
>> 
>> 3 - Before ASI Exit : Set sibling state to "stunned" (i.e. sibling
>> should wait before VMEnter)
>> 
>> I have tried this kind of implementation, and the problem is with
>> step 2 (wait while my state is "stunned"); how do you wait exactly?
>> You can't just do an active wait otherwise you have all kind of
>> problems (depending if you have interrupts enabled or not)
>> especially as you don't know how long you have to wait for (this
>> depends on what the other cpu is doing).
> 
> In our stunning implementation, we do an active wait with interrupts 
> enabled and with a need_resched() check to decide when to bail out
> to the scheduler (plus we also make sure that we re-enter ASI at the
> end of the wait in case some interrupt exited ASI). What kind of
> problems have you run into with an active wait, besides wasted CPU
> cycles?

If you wait with interrupts enabled then there is window after the
wait and before interrupts get disabled where a cpu can get an interrupt,
exit ASI while the sibling is entering the VM. Also after a CPU has passed
the wait and have disable interrupts, it can't be notified if the sibling
has exited ASI:

T+01 - cpu A and B enter ASI - interrupts are enabled
T+02 - cpu A and B pass the wait because both are using ASI - interrupts are enabled
T+03 - cpu A gets an interrupt
T+04 - cpu B disables interrupts
T+05 - cpu A exit ASI and process interrupts
T+06 - cpu B enters VM  => cpu B runs VM while cpu A is not using ASI
T+07 - cpu B exits VM
T+08 - cpu B exits ASI
T+09 - cpu A returns from interrupt
T+10 - cpu A disables interrupts and enter VM => cpu A runs VM while cpu A is not using ASI


> In any case, the specific stunning mechanism is orthogonal to ASI.
> This implementation of ASI can be integrated with different stunning
> implementations. The "kernel core scheduling" that you proposed is
> also an alternative to stunning and could be similarly integrated
> with ASI.

Yes, but for ASI to be relevant with KVM to prevent data leak, you need
a fully functional and reliable stunning mechanism, otherwise ASI is
useless. That's why I think it is better to first focus on having an
effective stunning mechanism and then implement ASI.


alex.
