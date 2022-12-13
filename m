Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7C64BE2B
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 22:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiLMVBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 16:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbiLMVBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 16:01:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A8120F6F
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:01:31 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDKx41X004250;
        Tue, 13 Dec 2022 21:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gbrSn/7EhxupjBTHL0yetoJwcpnr6E0M+nWKZC7gbPk=;
 b=qDcLMhATJjtPgqf7X/N3x+0YsuMOl6LCr7r3WUZEnz9Hs9fNRRebq7v12eRt2O0mnQuI
 BGOd7vVY4Z4oboKKFjKy8X/HqvPfQOi0kGlOa7gUVNQUfaduLrzgGYjOy9WCIQe1B/w5
 y1N62WkkZDpAXEurNyZSqwpD+6BK0Br13iS0Hhajl7Hd8f7/2hOp5/gEvkuI0a1/x8la
 zrWjpPAt0fk8iNNcRpoM6rwzN7r4d4GL/Aq0L/iunG3J6iiveqE/eHSHh2r7+wnjB42g
 Snk/+aLH5gOo85y13U41kYTboYXhlYn2Id+6AidGsNmIzeWn3X2zitDvG94NOiWYc9NP KA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewr8nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 21:01:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJJ0YZ011751;
        Tue, 13 Dec 2022 21:01:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyenmu3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 21:01:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltKeGUWIDunqY6LWX1MWpfY/fjhxJP3axhbpgJtku2HSBPGPr8QxaPoFHsu4v2Z9XdKc6ITvZkByD7okSL1PrGUXdiO81bsEVber8YWpqMUCpePAHwBzvbbmKghK0xMj/xmqaPt/KMtQZUgBCi1lKZSw2feNGk1+UayyCX8cG2Y4k+2AwHRCw9Z5gKVF1LixkzL1JHT3qkxzwqliXxpGxxX+XeGlg9QPNpTPj+cnOGktV1fEi03hq4EOLM94V1U2AHgi4GBQpIT0u3mG7e6VnmlBydHAsr0t3YjywgDp/37kNq7ir3yNyCIoFhKW9Pv+7SRcAf2lWnULL0BpG1bJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbrSn/7EhxupjBTHL0yetoJwcpnr6E0M+nWKZC7gbPk=;
 b=Pzbxf47DWoou9B6nHL10KUUrcFl0eyMXCQqf7XJ9w2wfS4FN/55Zr3Gc8e9uxrddUoJ6zcJBcQ2RcbxoFRHL2RidMoQfyse5Fz+xiZmGqCyoZe4VBk8BsK2iJUhWaVq4v9gihCl/BIXxoAxnOVzn/8ztiHZPvFpC6mhOjCYSTOp9DS5hK7vm+Yrl0RZJqniekaMGwUfEY+VcU0E66QfUWH4NQxqecjntoagotgVsfOq/ysmk+hf9pliWheM68oqrzIR3jR905ajqpbAOIhDF97vWOffugibW4aFmw3yBH7fDRRDB7czS4SlWUeCXjo5KqbOucEU2EZg6oVS08QOm8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbrSn/7EhxupjBTHL0yetoJwcpnr6E0M+nWKZC7gbPk=;
 b=S8jMD+nwpnw77LtWax2rWWyxqJ0RhaMIpoq7t5YqKCpg4gMs854Ugr2hupzyNqPX4ffJQj1qoW+e6Txmm3pWCXpRYJpaZho1BuDDzphZMSsXo4JkPy/TmLWMxq3ybITa79/LXK9GG3vci85YqJ7to0HMOXVO9bLeRPQNIu7AQpE=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 21:01:25 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 21:01:25 +0000
Message-ID: <ae08a80a-bac0-fbd2-2e8d-278c8609efe4@oracle.com>
Date:   Tue, 13 Dec 2022 16:01:21 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V2 2/5] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
 <1670960459-415264-3-git-send-email-steven.sistare@oracle.com>
 <20221213132309.3e6903e8.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213132309.3e6903e8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0049.namprd04.prod.outlook.com
 (2603:10b6:806:120::24) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|MN2PR10MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: bebb798e-ad29-41e7-1a24-08dadd4d3154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEjicjQAcwBzHNrfXBB9Vz5fyhX0JTblPWgy4cVshKgW5wNgy0l1y2iTEmS3mqMM/W4Lw6F9q3nqaWqy7Tnw11251xwNb2wMFfg1HyEdG4lxicBVj5ohM97urnXS3tOiqdxRf08GQcBWBAcJYxCHe4EcUDc4N069DDjaVLTN8eLpfvW/NzCpVBP9Ps6xpiE4SWFlL+HR0FgIC97MWrQ22HwlBt2abOOMez9sjm5Tn7asYD+NgtAGQPWAljmwyGD9KeusqocDbm9ot8m8XWY5xzHfsl0lqWGAopHSI3Lm21cRjxyixwKexSe/KU0jnJb2e64G1YnWPfxg4zK9yKx1tYvz2p5O1mABOpu7WaAU3UmVOrLr2ZEqHP4JLE3MhkkpAPdApfrGKCmfqinXHWPd7DlqbVZbiO9DMKQe8SyMoa1h6WT4WmjV4rW6YFHHk4Xg2NC/R/tJiv0LRI/upbkSaZ1edI2SWdjmjpQSn4mZ2PA5LiqyVhco1nITtDrRsDyzVW6YU+Prp0LiUm0t4DMzg6R7Wnf5Jqdb3UYflleOJc38O85vBVeuy61g/t8m4qJQeZ5xfHrq85pKnw2x9DZv9ba1Rmau8XZUm/qC+wKUjeFvYSXkl6c7WTr8WCCmRMnkI9m7zv/3XTKZhYck20/zM4HTBiZ/QAHgOVh7+mjw8fB4sXpyZQRLmIo0hgK5AQinkvRos++vrKtBFB4k0nXxDGI02H6EUnsgl+wanWJM+Jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(31696002)(41300700001)(38100700002)(86362001)(36916002)(6486002)(6666004)(8936002)(478600001)(4326008)(66946007)(316002)(8676002)(66556008)(6916009)(186003)(2906002)(83380400001)(26005)(6506007)(6512007)(66476007)(53546011)(44832011)(2616005)(5660300002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VERucEpURXVEVlBZb1hCRldYNldtWVhnNmp1UGNRajNTUG52T3pTWEl4U1VO?=
 =?utf-8?B?eE9yQ1p4NWxhSnFXUnoxV1ZaaFhpWVNJMUN4Q01FSWR6SFp2VmdmQStya1ly?=
 =?utf-8?B?eHFwZDBFSjBjRjJRMzI3V3c4bU0vQTlpZ2lYWkI0WU5vbSs3ZWN5NWJ4R0w4?=
 =?utf-8?B?T0l2Z1NSMFN2TTBxS1RGNzRDa3BqTjFkZkxsU1o2V1h4OTc0cm51SDZ4cjhV?=
 =?utf-8?B?cHgvZEtIZkNxM2d1OU1WajFocytKWXRwM1NkRk0vdVB2Z2w4RVhQeHZwa0hz?=
 =?utf-8?B?NGxTMnZZcDBUTEN3WjloeVJERE53VTR1VCsvV0F1SmJmWVNJaCs0UTI3dytp?=
 =?utf-8?B?ek5jK1BrZWkzdW1lbldUZmhnYU1WdXE5RWxlWk5qTm81VFZXeEdETXpBSUpy?=
 =?utf-8?B?aEtFam13WHFOM05lVUMwaUU4VWFCWm05RkwxQ0YzTnhmYTJxZDNXMDFVTU9t?=
 =?utf-8?B?Q3N6cVI3NVVHUm5iSEZMYzV5dzEvSmlpeWRDN1lwa1Z6M0EvaUxTWHdPOC9Q?=
 =?utf-8?B?ZVlHeHhPb2dRWStZSXJVbEk4MEVBdnQwZDZHdjI0cXJvMTZUdzdUKytrNWll?=
 =?utf-8?B?Yk4rU0tQa3FFczVma0tGOEx2ZFVDTTUxVXN1NDFEVncrSXNqV3V2OFBLK2RC?=
 =?utf-8?B?KzNCZjc3YVY4WDhOa0tkYnpKSE5CSmJqSXpUKzNLelgwY0ZvVGRPckUrNERq?=
 =?utf-8?B?d0d2UVF1QjFub0pIS1JwVHZpdFZSaXZPai9ITUpTQWJpQnhTSytiWExRWGV2?=
 =?utf-8?B?OFNPbjVuQ1I3eWlDbnhBaHRVZnQxMXZ6VTZGdTBjR0tNbG0zdm1IMW5lUHc4?=
 =?utf-8?B?RVBkaS92WjlGZ3FFUE54dmpPaXlvU2YyeFlNa1VqZ0pxN2M5VkFYN3grZXRN?=
 =?utf-8?B?UC9nVUVmclU5L1dvYVh3bG4vUGFGUVNuT3ZraE1EL2NKcnl0RHh3OVZTWm1E?=
 =?utf-8?B?NUtTajhqSzBXSWZjakFjVHVRd3FWNGxJei92akRDK0txVFkwMUZENFJtaDBC?=
 =?utf-8?B?VEJxczB5WWhpemlQc09WK2NzWjJYalFSQXNpa1pnbW0rTjczellRZGxBYlpr?=
 =?utf-8?B?QmhWcTlrQkl3RTBGdWEwRW81TkphYTd6cW9yK0xwazNqTjE4Umd2MEpwa3Jk?=
 =?utf-8?B?TkVXSkZiUGhBUDlsMmhGY2dtVTFnWWpITk9MbE9XaXk2V08rTDk2bWkxZExE?=
 =?utf-8?B?N09Fbm9wM2FMUTY4bmhBY09sQjVNUXRGVFBtazg5OXU4L2xQK2xTUHZOdnQx?=
 =?utf-8?B?NlA3dzlHQWwyOVV1d2greHdVbXJIRmVwaFVNQllONTNnR1pNUE5ub3F0dEZm?=
 =?utf-8?B?Vjdsd3RrdW82MFRKcCtDbnh3QlFHUk5zRjQwTGc2NFlYKzJKMEpaMjM3S0J1?=
 =?utf-8?B?Y0FjNXgxc1k2dmFYd0xST1VpR05BdjcwMDM1M2YxZjc2YWNCeVZHcFRyVTMv?=
 =?utf-8?B?OTB4Y0VpRmRISjhQdWtiL21GSVNXd2U5YWd6azRmTUFkNU0xZDZxTmVtSmNr?=
 =?utf-8?B?RTArY2pQbUxsSnVHZlhPU1ZhWGVsN0VsRnd1WVRQTGpGbm1zRmdJVmFzcWtB?=
 =?utf-8?B?WDZLU1FKcEdjZytQVHhkL3VuZzRMdVFlcU92TS9MTnZPN1M3TzdkYWVIYlN0?=
 =?utf-8?B?cmVWK1RPaU1UdVpCdnRyQlRCa1VKT1FqRVd3NmZWNk9CNnNFN3RRNXNadG1F?=
 =?utf-8?B?N1NaR2cxME5mNzVhT2U5YjZVVzg1emRPQkw5azZrMlh4Z0JvaGk2M0pjeDVJ?=
 =?utf-8?B?czY5ZlB6MS9DU25BWCtlQnkxdGFDTXB4SUpEKzJRQmt3eERzS0NnbjU3Nkp5?=
 =?utf-8?B?SEdueVVqRlJiMXlUcEJSNm1kYWJpTHBZekY1SnorRTNmNDJ1M0xIMURsZkxG?=
 =?utf-8?B?dk9EQ0E4RG0vVFI4eVhWK0w4T1RhRm10LzZMUWt4K0Uvb3hXazRUa3hwOGZI?=
 =?utf-8?B?NHUxZlNxczd1U2tyZDUvNXczOFZ2SWc3aHFwengxc3lxRkw2anBPUDJYdlVZ?=
 =?utf-8?B?MXVMeWcrZyttMnpubEljcmp5M2dlK3VwVURCYjZ3SnNOY0xVeWsyU0FHZ20v?=
 =?utf-8?B?c3V2cFAyRnlxNDBRNVpmRWo0TFBRV0U4S0pTU2NMZG4wZyt6TGFMak5lVThm?=
 =?utf-8?B?dlpMa3RBWmsxeERzN1hyenUxckp2dmF5QVZjQXlYS01EZkcyQ1NrdnhpRUhw?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bebb798e-ad29-41e7-1a24-08dadd4d3154
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 21:01:24.9829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+naKT+u0/UxgOfmcs7+4RNuF1XRijAIV6ZXsn6p77g0EHXudI53Wd+vzsJO7ojepWAtrs/Dd5a45Kfq3Uo79SZ3enySrEha3v/bzBYpr1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130183
X-Proofpoint-GUID: 3sOrH4qCzoW_7sNElLPbVNzW33ojnOwo
X-Proofpoint-ORIG-GUID: 3sOrH4qCzoW_7sNElLPbVNzW33ojnOwo
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 3:23 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 11:40:56 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>> dma mapping, locked_vm underflows to a large unsigned value, and a
>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>
>> To avoid underflow, do not decrement locked_vm during unmap if the
>> dma's mm has changed.  To restore the correct locked_vm count, when
>> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
>> the mapping's pinned page count to the new mm->locked_vm, subject
>> to the rlimit.  Now that mediated devices are excluded when using
>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
>> the mapping.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
> 
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 80bdb4d..35a1a52 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	struct mm_struct	*mm;
>>  };
>>  
>>  struct vfio_batch {
>> @@ -1165,7 +1166,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>  					    &iotlb_gather);
>>  	}
>>  
>> -	if (do_accounting) {
>> +	if (do_accounting && current->mm == dma->mm) {
> 
> 
> This seems incompatible with ffed0518d871 ("vfio: remove useless
> judgement") where we no longer assume that the unmap mm is the same as
> the mapping mm.

They are compatible.  My fix allows another task to unmap, but only decreases
locked_vm if the current mm matches the original mm that locked it.  And the
"original" mm is updated by MAP_FLAG_VADDR.

> Does this need to get_task_mm(dma->task) and compare that mm to dma->mm
> to determine whether an exec w/o vaddr remapping has occurred?  That's
> the only use case I can figure out where grabbing the mm for dma->mm
> actually makes any sense at all.

The mm grab does detect an exec.  Before exec, at map time, we get task and grab
its mm.  During exec, task gets a new mm.  The old mm becomes defunct, but we
still hold it and can examine its pointer address.

The new code does not require that current == dma->task.

>>  		vfio_lock_acct(dma, -unlocked, true);
>>  		return 0;
>>  	}
>> @@ -1178,6 +1179,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>> +	mmdrop(dma->mm);
>>  	vfio_dma_bitmap_free(dma);
>>  	if (dma->vaddr_invalid) {
>>  		iommu->vaddr_invalid_count--;
>> @@ -1623,9 +1625,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  			   dma->size != size) {
>>  			ret = -EINVAL;
>>  		} else {
>> -			dma->vaddr = vaddr;
>> -			dma->vaddr_invalid = false;
>> -			iommu->vaddr_invalid_count--;
>> +			if (current->mm != dma->mm) {
>> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
>> +						     0);
>> +				if (!ret) {
>> +					mmdrop(dma->mm);
>> +					dma->mm = current->mm;
>> +					mmgrab(dma->mm);
>> +				}
>> +			}
>> +			if (!ret) {
>> +				dma->vaddr = vaddr;
>> +				dma->vaddr_invalid = false;
>> +				iommu->vaddr_invalid_count--;
>> +			}
> 
> Poor flow, shouldn't this be:
> 
> 			if (current->mm != dma->mm) {
> 				ret = vfio_lock_acct(dma,
> 						     size >> PAGE_SHIFT, 0);
> 				if (ret)
> 					goto out_unlock;
> 
> 				mmdrop(dma->mm);
> 				dma->mm = current->mm;
> 				mmgrab(dma->mm);
> 			}
> 			dma->vaddr = vaddr;
> 			dma->vaddr_invalid = false;
> 			iommu->vaddr_invalid_count--;

Better, will do, thanks.

- Steve

>>  			wake_up_all(&iommu->vaddr_wait);
>>  		}
>>  		goto out_unlock;
>> @@ -1683,6 +1696,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	get_task_struct(current->group_leader);
>>  	dma->task = current->group_leader;
>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>> +	dma->mm = dma->task->mm;
>> +	mmgrab(dma->mm);
>>  
>>  	dma->pfn_list = RB_ROOT;
>>  
> 
