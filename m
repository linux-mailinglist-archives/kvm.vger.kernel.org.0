Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8315EE6D0
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 22:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiI1Uux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 16:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiI1Uuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 16:50:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770AD18E22;
        Wed, 28 Sep 2022 13:50:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SKdoIK016416;
        Wed, 28 Sep 2022 20:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kSAEOj0KTn5LPy98iOK6kKu+ooQkFvDnMmCyKdA2G+0=;
 b=Ckw6RDQso3GO3W/MclBuEBQd6KtPPb/d10R8Ai6xeZKU7j2+Cle9vJnAE0obz47OzuBT
 IOM5+1gB3wFfYbXVnTD6QUu36si0AQ59KJAMPJKd6Hoyr/I+pR93+64bOTgwHtDbkxC1
 rR/iRDBSYybcmcwRRcCxhvHVD5aVopkReDoRm9Uqrh7GbPvo6EV7SxN1KHYEs8sLL2fP
 PlzR6tgWbOsMTAzaCoXpQMcciZx2hxap/pQBPfmwPfsiVNJGhdfB091hW9KyonsBmiC5
 c1AbGgoU4v6dOnyqtZ63k6nyIl3YWTx1nxD75BDhYqTxneiNfgw44ZDf61Mp4tHF8h72 UQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstptmat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 20:50:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SIugKP002198;
        Wed, 28 Sep 2022 20:50:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6p1au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 20:50:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWl56sI6zZ+iwRqUasB/t920oovgB8PvT9B+rgzia90w7DOZttxhCVc/EZntDELvwyjuNpTL7t62PNT/DoWW/8oMnGHxRDuf4qCb9dnNt3BIMjCH0FQBSOkuBSb1985+qQDM1vnDz74QvhBWphdsiQA+WFu4QEyOxI/5RDAo+FbrRcxO/+XLtNwPEY2p+iDVMzR0riPJp+LkkaAW9PypOt4WkwiVuRSOfbo/3rhmqrqJDnZrb7Kofr9xcwf28I7iR7+teclW7HsjkCwRy6DMIGzXHkB+k0xHXrFTXGK8PkJw/zxyfqNdVvdS5izSJqyLte1LyrHnVCNZLGVVEL5KNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSAEOj0KTn5LPy98iOK6kKu+ooQkFvDnMmCyKdA2G+0=;
 b=hdZGN3FYiEKrufSz1LVp5ihuI7GyAs1a4e1DfH9XRjOlclvXJAdT5qf5nD2wdnNjstDWU6htPIpnmYNisTE0YT59sM5i6OnwemnjmX3L+agl3gy31gWMPq81iVvXkkOEPHg76ssPS3sWUEqOfOs7oPZbmLRJrQnQcFtewVJuuHYLOTmQ9TN3ZKps4eYxjgw/yu8hSBBLNS7amkk3hPmlRZmjXqumZRBkY+Pn8zcDVeL1zDb878zvibsXTVq1lxRxrarfXDyMSj+4RIw6mQy1yvmm0jZdZXjoSt35/3dh0p1jbW7cXF1NGvJKyUB4ePxZSG0jdqKSRHq58kFgxSWg8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSAEOj0KTn5LPy98iOK6kKu+ooQkFvDnMmCyKdA2G+0=;
 b=NaYM7kZwwnqbGQIGDe8rGNMxPq+BOmKVs49UKbAvOI4oI+gHhQTANRilMkR2brnmKHKLT7fWIfgid31hnTFg7yocP4hJSuJeqopFcNXgU1dVoQYwJ96hQxfcBF1LsBK281WtBw214or5hIOBJ7erDUC4nLb+J519/bM2xDUUXFs=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 SA1PR10MB6367.namprd10.prod.outlook.com (2603:10b6:806:257::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Wed, 28 Sep 2022 20:50:19 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::95b4:7be6:3e45:d64e]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::95b4:7be6:3e45:d64e%4]) with mapi id 15.20.5676.019; Wed, 28 Sep 2022
 20:50:19 +0000
Message-ID: <c48a0191-d081-aad6-c65c-0c030dce8dcf@oracle.com>
Date:   Wed, 28 Sep 2022 16:50:15 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-6-seanjc@google.com>
 <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
 <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
 <YzR7ezt67i1lH1/b@google.com>
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <YzR7ezt67i1lH1/b@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|SA1PR10MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae113df-616c-486b-5648-08daa1930dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TapKQvfYHwVPMqEErzp3N7HC6taE30IXi1vjYcpEVqO8bh+oriUa7T7EocLD32EXnrTjgEx1RPn5FKaXawXGWVXi9oIM2sigWra1VHCoZlR25C+maus1hV35bTwfA+OseQqqaE08iL0bSqJD2d/jQw0EgRC4/vm05V1dkf5yrNpRSgQmduOr+agD1Xf26kATXSVauuChR/ys0D1b3W/avjupZXEICH4hU1NglibNWV1ecMXKP6oLEBpROSJ75NWhNVmusKz901KuvKeacLELSlEsx5FkRmBzVvqRMIuNk8t4fdq6nGfktGcLGU5WXCQUpgCVPiKVXsdKIwL75WV5737kAArxjCZl3mN7BPYdCI821aFrzSVWwsPM8Ey1OLCBp3TnRU8lcPA2uVJ5YT4V+J757na8SGU7n/ZaSn87mr+lbGOpTp4o9V2rrzgA1UgYkguRgcIS7LzixLE1tgmbOWRlnKw2+DlRELV3XPoySZMJFtqHbr+mOiFHVgrgllVI/uRRZcka74Q1yj79yhWmSw12XPcxhXJqBg2TkFbfV9vhCaze4h9fHQYGO29BC96zZRPg31dijWIBjAPbZhrwuX55T/3GyqIaRQx8X6Zm8ulUoucuec9Qbh3HSBs5LE4p11NEIucyO6LBOJUwEwNTZS21XpMO5MdRNs9JbfH8mM5ozqnLYsaVuRh9F6Uz3S7buocinYN4LoM2BC9ybO2oMD58f2h2/sZYDM9E0RtbhbEwg1Q9T80k31F8jP78OTVN/duTLVTYxsFoFvMFSI5tXw0g1uGYgfMErXCiHfbvnj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(31686004)(86362001)(31696002)(66946007)(66556008)(8936002)(36756003)(66476007)(2906002)(41300700001)(4326008)(8676002)(316002)(54906003)(110136005)(5660300002)(6486002)(83380400001)(38100700002)(53546011)(186003)(6512007)(2616005)(26005)(6666004)(6506007)(478600001)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXRNdU1mMXhaOGZIek51T0ozTTM1VHJFTlhmWExScTdWdVVZYUhjYmFyVUIw?=
 =?utf-8?B?WFBrZThvOTZmNDdMUTRHc2pWZUhVLzMzWnlPYVQ0cVIrTFVCT1o5RTZqcjZq?=
 =?utf-8?B?MnU1c09pTmQ4NmozNUlGVzhTYWdyOTJ6eEVlZTFKWmhCOGY1eCtySkt3c1RS?=
 =?utf-8?B?d2tkallHeUNhZXdIQzlYWFZuczY4VCtUYjJSK1RJTktFZmJOVWcxV0xZM21s?=
 =?utf-8?B?SE92a0trKzl2VUFOZjNFU2dNZWFNWkg3TmVDUXBpcDZCTUFMcmlJQjYyZllX?=
 =?utf-8?B?UmJ4SW80TWs4dWR6VTJhWVh5K01TVEV3WVRvZXBMUnp4VDVRV1lPNFFyaThS?=
 =?utf-8?B?Z3pHbmRQYWR5Ulk5M1RQdW5EYk1EK1o4Z2xwSHl4S3c3VE52cUFQaDdQaHh1?=
 =?utf-8?B?SEMrTjdOYitaMWtCaHN5QjhkM1VxSlRkR1N6cFR0WEpMVUJROWVObTlXUW9k?=
 =?utf-8?B?L09sY0xacmpobmlCbGp6TktLTkd1MXlxcHc1MmFyQVg2aDl2MWdIaDByeFB5?=
 =?utf-8?B?Mys5Z3dySEwyN1hQOUJJYnNtc0lqeHZDQWRJVVFVM0w0UmlIM2lHdEpIWkNs?=
 =?utf-8?B?YzFKajBoa0k3dmdTU1BwTmdoaFpJMGhmcFZqb0E0S2V0L2NWQ05hSWhyVUpx?=
 =?utf-8?B?VmNLNTVHN3lWOTFRdlR6NmJkUUxkbzBZTnlVWklTWVJkeVVrTjRBTlUwYWM0?=
 =?utf-8?B?anlNOU5CVFhFb094bWdXS080eDBKUHd4bno3YkZVUUlnTjZBV0VXV3ZZbVc0?=
 =?utf-8?B?WVBDZzB6MGEyVW9jRXNWOUVTd05haG1YOTVOVEtXdlZQbmZRQlcxbCtLSXYy?=
 =?utf-8?B?WHBtTVpKai9wY0h0aE5IOEV0Zys1bkdqd0R5aFVaL05JWGp3U3BKN0VqSHZt?=
 =?utf-8?B?dXBZU2ZDTERZb1U1SjFNeEN1TXlGZkxPSG01VERqVjdvQ21kaDhmRmVvOEgy?=
 =?utf-8?B?Y3pkSFNsTGxJZXM1RnY1Ukt5OHpqa0N3MlUrLy9NbldHcHg2ZEFZQlZXYWsr?=
 =?utf-8?B?OXM1MkNKaTVsNlFXeGtzVURRS2xkSUZQRnBHVU9NWFpUZGhPWkRiM0htdkMr?=
 =?utf-8?B?NFdUS3hNOTl0L1pQZGhkOWlBczBwUS9ZYWFqYk9SWmhlYk5hV0o0UktDSXpw?=
 =?utf-8?B?ZDhEQVJXRHBHRE82dTB4NGdFNHZ4WDU4SE5TUDQzKzJldDFtaU04SHpkNkk2?=
 =?utf-8?B?YjlWSEc2TWZiK2FEQUVPZUd4M0srMGpYMkJBRkJ4S0FBWjJjY3ZNbUFYNG1r?=
 =?utf-8?B?VEJiL0Iyc3dlRFFmR3VJQmh2WEg3WTJCVFFlWmpmUGgyV1NaRVJMQ0doMm1x?=
 =?utf-8?B?NkxwYmhoRzdjMHRaTmZFZkttaEQ0ZDFZTHVuTWxDNm1wdVY2aVRvbGd6MSt1?=
 =?utf-8?B?ek9Sc2xxcmhiS01tOWp2bDRiaWFKOWowdzhpNVhxOXp0V3B1UG5LSTRPWUE4?=
 =?utf-8?B?QzFiSC9YWUxnQjAyYkJHd09vakdyTnZCNVlZRk4xck9mYlpHVmxnb1ZFa0JQ?=
 =?utf-8?B?bndxU0o2UGsrNGtCemY0R0pLaFlRd3REbXBHRWRUcmZnNUM5b2VnT3YwZ2o4?=
 =?utf-8?B?aDhrMlk3aHNtV3Z3ZkFyVU9GVG8wWDgrbjQ1Y1lES1VkZWs5VmVBMndqQjh2?=
 =?utf-8?B?Q3FBRGFvb2tmWGpvM0JYWDgzWU1sOUd0VzNEaldTUHZGWDBOS1creE8zcVQ2?=
 =?utf-8?B?U3czamlucFdFZmc4QjAvSDlCMDcwcHd6NkRqeHp4N0Y3VUVIRXRheGNyNHVX?=
 =?utf-8?B?cGhxVUZXdDBjdHhGWFZxQ0w4LzVOUm0vbUJqbU9pYkl1Z2tkYzRXaWowbnpq?=
 =?utf-8?B?UWdMdUowVThDZEd2c3VOMlp3ME1HcDFqM1FDOXBuTU9PQ0xaRmtRR0M4Q0pp?=
 =?utf-8?B?NGpub0tWY1g5MFFLZlZobVBuT2pZNm93WXJNU2pHd2YwS2ZsNXBVaGpzS2F2?=
 =?utf-8?B?Z0Q4YU9ZR2hnRWI2eS9XUTZYRURNMjR4cWo4aGFxcy9rOXQ1bVJXb2FyTEdu?=
 =?utf-8?B?M1VmMXhmeEhyaktZemVBUHhGL2dGWnh3NEhWT3hiUUxSeXVzeGVnUkJOdG9u?=
 =?utf-8?B?NGJmWWFwUEZITGZSUFdmQkF3a3A5cDUxVkRtc2RzeUNvdm1MdWc2U3V3emFX?=
 =?utf-8?B?anp3TkV6M2FJY3hZS2E2d1R2SzZmWGFBazdjRjNsQ1VDWjIzQW1tQitEeUZh?=
 =?utf-8?B?bmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae113df-616c-486b-5648-08daa1930dd9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 20:50:19.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGcPeNHnWkLl3CT0uGS2Ck6tp6d+ucrnfF+L6Jjr0bssQ+thmxVdTaJTRlcaa4cAS/IWW9WneWKcJ9aTkxJOKidSPfSsXLztbAMnV1/B6OE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6367
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_09,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280123
X-Proofpoint-ORIG-GUID: MmpfDlTOcld_uYUEd-LsrJPQYQcO0cZv
X-Proofpoint-GUID: MmpfDlTOcld_uYUEd-LsrJPQYQcO0cZv
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/2022 12:51 PM, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Maxim Levitsky wrote:
>> On Tue, 2022-09-27 at 23:15 -0400, Alejandro Jimenez wrote:
>>>
>>> On 9/20/2022 7:31 PM, Sean Christopherson wrote:
>>>> Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
>>>> it against the xAPIC ID to avoid false positives (sort of) on systems
>>>> with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
>>>> APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
>>>> it's original value,
>>>>
>>>> The mismatch isn't technically a false positive, as architecturally the
>>>> xAPIC IDs do end up being aliased in this scenario, and neither APICv
>>>> nor AVIC correctly handles IPI virtualization when there is aliasing.
>>>> However, KVM already deliberately does not honor the aliasing behavior
>>>> that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
>>>> resulting APICv/AVIC behavior is aligned with KVM's existing behavior
>>>> when KVM's x2APIC hotplug hack is effectively enabled.
>>>>
>>>> If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
>>>> piggyback whatever logic disables the optimized APIC map (which is what
>>>> provides the hotplug hack), i.e. so that KVM's optimized map and APIC
>>>> virtualization yield the same behavior.
>>>>
>>>> For now, fix the immediate problem of APIC virtualization being disabled
>>>> for large VMs, which is a much more pressing issue than ensuring KVM
>>>> honors architectural behavior for APIC ID aliasing.
>>>
>>> I built a host kernel with this entire series on top of mainline
>>> v6.0-rc6, and booting a guest with AVIC enabled works as expected on the
>>> initial boot. The issue is that during the first reboot AVIC is
>>> inhibited due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED, and I see
>>> constant inhibition events due to APICV_INHIBIT_REASON_IRQWIN as seen in
>>
>>
>> APICV_INHIBIT_REASON_IRQWIN is OK, because that happens about every time
>> the good old PIT timer fires which happens on reboot.
>>
>> APICV_INHIBIT_REASON_APIC_ID_MODIFIED should not happen as you noted,
>> this needs investigation.
> 
> Ya, I'll take a look.
> 
>>> It happens regardless of vCPU count (tested with 2, 32, 255, 380, and
>>> 512 vCPUs). This state persists for all subsequent reboots, until the VM
>>> is terminated. For vCPU counts < 256, when x2apic is disabled the
>>> problem does not occur, and AVIC continues to work properly after reboots.
> 
> Bit of a shot in the dark, but does the below fix the issue? 
The patch below fixes the problems for all the scenarios I have tested 
so far.

Thank you,
Alejandro

  There are two
> issues with calling kvm_lapic_xapic_id_updated() from kvm_apic_state_fixup():
> 
>    1. The xAPIC ID should only be refreshed on "set".
> 
>    2. The refresh needs to be noted after memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
> 
> and a third bug in the helper itself, as changes to the ID should be ignored if
> the APIC is hardward disabled since the ID is reset to the vcpu_id when the APIC
> is hardware enabled (architecturally behavior).
> 
> ---
>   arch/x86/kvm/lapic.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 804d529d9bfb..b8b2faf5abc7 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2159,6 +2159,9 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>   {
>   	struct kvm *kvm = apic->vcpu->kvm;
>   
> +	if (!kvm_apic_hw_enabled(apic))
> +		return;
> +
>   	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>   		return;
>   
> @@ -2875,8 +2878,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>   			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>   			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>   		}
> -	} else {
> -		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
>   	}
>   
>   	return 0;
> @@ -2912,6 +2913,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>   	}
>   	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>   
> +	if (!apic_x2apic_mode(vcpu->arch.apic))
> +		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
> +
>   	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>   	kvm_recalculate_apic_map(vcpu->kvm);
>   	kvm_apic_set_version(vcpu);
> 
> base-commit: 0b502152c0b8523f399bdb53096e2d620c5795b5
