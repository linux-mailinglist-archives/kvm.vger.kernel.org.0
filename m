Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A304ED4D6
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 09:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiCaHcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 03:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiCaHco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 03:32:44 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A72F1F2DD7
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 00:30:58 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22V0n2V5008997;
        Thu, 31 Mar 2022 00:30:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=tqpmjMhyEskKJh5GavUdoUFeZbq9Iz7IpKq5g9fwmGs=;
 b=mYR8aQXlzSDNQQ3djrOkillZ9lCxTw5BSOQxWy83tEpbDyXTqjvqFVUp4vlFeOMAYkZo
 dvC/CJuUNKe1g2MZXGTUujwaIT/74LEqoxNBLSTJPBNnJl7YF/m7cSZpwmiwj9PPzuLu
 h8GY+eknS5MZPwgcSNt4O/SkU8XzB5BZnXm/85xS0uGg+pKY3Kxj7S+LWpeOrQVHYWLt
 j+IQOHtI8Kxo+ry13HUw81pf0JGdD10+hSDY6iYoOMRGt7gKx7N7OyXkBH575xx4EAbW
 lrU8WDbtUBRjEwvK5efFyw3Y7etZbVCJjIUjbl1qpUtqPgWk7TBbwFxVEUVeOMklFh+w ZA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3f21wfad1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 00:30:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4e7NlbibWo1OfABtcHX8HLrdKU46GIyZk/7GVmEs+J3arCkMAOw3C5oPcQWYEmLEWIae6vcV6AEpjs7bleDH+w5BTmHoCH0fEioCfMWyx02y9Fs3e5oZMFwZduS/sI++Yw+BdvXNMafXDBJN6KQtOaYXDPmm9wtFJ2sCc9RocMOAAIrhhFDrW2a/Qa14dKPpnh9vz2T9bPWbZxVTMUuN8D0w6YrPRgeMHugPCdduaUiYqrquhoi5XwJFngJLBJ7xeooExtwOcrDTvrMV1JKI2qNuuZXFyoaKCmQgediiOabCrd3KAqZzCE6J/7rNTrGtRLn7dqMBJc24cTfObfHOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqpmjMhyEskKJh5GavUdoUFeZbq9Iz7IpKq5g9fwmGs=;
 b=LShBtk+Z+LlrbXCoEpL+KyOS7vGYXQxwqh/naRv/qTFiknbRBg5Yd58+v8LcuqAl1x85/2ys6i53ybp+TwJ4yjXWiy6MC//jWO/phNVKFnwodfZ69zr84G8VifqIqrZVYXDDtPOHUwFhpncJcBuZsr43MfEAObmOxqbhl+gQMaZCvwWu+ZkTdM6SvocLGpZMBOsh5Xq6lA+6WrwVBA7IlIabuFZIwTXvE5SZSlo1CW23s9edYGVsODbYcvUK/Af31v9ET6KPQVdiF/Y7Qz1HKplctNshUBNav1V7xKapsnjpbXguHRpZUqpZMKCbvFf66acdokZ23sL4yeDY2kSgaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BY5PR02MB7076.namprd02.prod.outlook.com (2603:10b6:a03:236::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.18; Thu, 31 Mar
 2022 07:30:50 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 07:30:50 +0000
Message-ID: <ae21aee2-41e1-3ad3-41ef-edda67a8449a@nutanix.com>
Date:   Thu, 31 Mar 2022 13:00:38 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for
 dirty quota
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-3-shivam.kumar1@nutanix.com>
 <YkT4bvK+tbsVDAvt@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YkT4bvK+tbsVDAvt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0003.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::13) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 514ee3b8-1b24-4b35-33bf-08da12e8614e
X-MS-TrafficTypeDiagnostic: BY5PR02MB7076:EE_
X-Microsoft-Antispam-PRVS: <BY5PR02MB7076F705FC9E87206F953C55B3E19@BY5PR02MB7076.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gzCcnAc9p1q9e0Y5cxkdZLFcBHSflIn2g12XfRdkRdkyvGIqNFtzsUSW0Qw9NcJlAa37jTYjObXgdo6aqdjwB903hme/flUNAJeRnj+NFXpb2FZu27NZIsdZ1R0NddE2paTz11lXGS59jGghBtvTfM9JSnPVqY3KNyJZbCUwTND1Y/XfDb7r/xwIE3z1qrEqCH0bZMDKQ5pXHJ7s/Zucdq0+8bpcb6KfzF/hWXgmtVhMiQ3rpw3y40NuIEvb+gYUKBFjHhhN4lpRogx1HeHQJb7/xdjLgZthSMgx6SyI9jyRX4lAuCZVckqdLUcpsAoCUCTxBudz2J8fYeSusHMp0D+KIBXKKDF+j2hJg/ZNxT/3MPlPkUpGurL3VXisY/MxKPtth4Nyb3r8FeCDUrR4dvv/yJikUecAxSZ4JZ8fuH2UsWWBu4M3W3DIEkLcWcywTZhRL5WMLkuto77YDTJJkPJXUm0y5AHqw68PgeYDcJGj5AunoRIIao/AGlolqVXSLGf5Cl1ce/z2KBmcs1zlVCUQuBPnSeR1qWmldpRgMrOeZSiK4wvsr6e4rN6yXN30ht80NmkUj+2qHtBE69VyUGmpGaw0JgzvPMWEQrFXmLIU2hu9BJyHsmTT18qyMIXZMyasOc7oOSR07KteK/YD/BcMDHpybn/QsMJhjRXl9fLdhi64myuQ1zbP0R1FRPJaACxzozhUGlZ9vPlMkWjmIaGsATlWAI3q3KdDOEx8la2AGcoP4+mz3dnMho7sKSo+2BQMg9K0dy1Nh3TA7Q8csA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(26005)(6916009)(316002)(6506007)(54906003)(6512007)(36756003)(6666004)(186003)(38100700002)(2616005)(55236004)(6486002)(86362001)(31696002)(5660300002)(8936002)(8676002)(31686004)(15650500001)(107886003)(66946007)(2906002)(508600001)(83380400001)(4326008)(66556008)(66476007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2d5Z0pyRldkeW80T2dJNnVzdDZIQTRvUmN0eVd3dm43RnVqUzlHQzRDM3Fl?=
 =?utf-8?B?Unh4cUpIRlFucVE4aUljOEFpSDZlcDlNR2ZLVUpiMmp4RUJMTkFDdFE1RHNa?=
 =?utf-8?B?L3A0aW85T2VHblN5aU9CTUd6aFNtYm05b2RrVnNMbWFiVTNFRnh5ZG1zSElu?=
 =?utf-8?B?RW1Sd0w5ZHR0bXlVc0w5cGJ1cnNPTk55YjJpRENFdVdyUTVzRUJURzV3bmpz?=
 =?utf-8?B?SjBaSEZ1dStVeHpKaXNsSTgwTEJVd1NxL3hYNUU5VEtUd0lIRUZiY2lIZ3NN?=
 =?utf-8?B?N1hzWGZwMG5lSzhqTFFpUEVrRC81L2QrVmN2aXRxRG9Xek1Hb1BSWjhkWjVa?=
 =?utf-8?B?UzFoQkZlQytiSi9JRjNzNVNJNkxVRFg4Umpwb0JHL2VjcExYd25ib1FQekRs?=
 =?utf-8?B?cEFtTFY0dmJJclNKLytaaTk1d0lKcFFnZjJ3R1Qzb2NIYVBLc0JaR25ZaU1G?=
 =?utf-8?B?ZHUweFRyQkc0ODVSa2V5WEZYcVc2QlNhZW1RV3A3Q21rd2lFenYyb0RKQnhD?=
 =?utf-8?B?WkhVVUtzTVAyNEl4M0ZVM092dkIyZnRrUmNscTlvOXdzdW1IZFhmZ09SVWZq?=
 =?utf-8?B?Z0hyaExDbGoxdkxobUtYNVhMak1obHlXWEVZb2lKZ2dMN0REWVZTWUc4VlNn?=
 =?utf-8?B?NmkzbGhBNVRHdlFlMG9mSXM3N2VvZHlUWHQ0ZDdnOWhQVWc1Z0w1Y05Ma2FY?=
 =?utf-8?B?VzlNUFFUVFBqdStDK0sxdzZuVE9VWkN0cStya1psekxHQkdjOTQ5dStCWTNQ?=
 =?utf-8?B?K3l1WDlQY2pTM1Bwak8yanpTaHZNNjh0OG5SWHBONG44cXUxelpoUEZKbHg3?=
 =?utf-8?B?c3JRNmZZSmVDbjlNSkZDMExDemZ0M09lMFRXWFhFbHI2MVVpSmZSTnZtb0pr?=
 =?utf-8?B?RUFXUDVxZ3Rud0NQb2dqRkV1eDE2T3V5MDhMZjRHSlRYTXRLVVE4QktOSTZi?=
 =?utf-8?B?MXJXZjNxL3hETHJ2M1dDMXExYjJyZ2JFSU1VQ3dNaFhtUVJlZVFqTzhjeHJG?=
 =?utf-8?B?VXcrVnZveEhTL0xBdXhZcW02SFpnTUFUbEY1cnNRRXpjSjRQQkpNdjc2VWFQ?=
 =?utf-8?B?Mmo1R21DTUllL1lxWTRmOU0rVXVLNENueEVSaVFscVYrZjdnVUlmd1dkSzFC?=
 =?utf-8?B?WU96OUNyRkNxazIwbjdUQ0R0MEpaL1RTb3lHVVhEN1ppT0w2K21mQXJUT1N6?=
 =?utf-8?B?NmRPWDFQdm91d01MTmVsS1RFalI0Qk1QTFcwNW4zcEp6Q1M2aHp0bVpqTDU2?=
 =?utf-8?B?elZ1YzIzY3BlOFlCczhWVEp0b2IxWk0vcG5QM1N2NUR0anNhT1UreTZjdmhx?=
 =?utf-8?B?YThDc3Zzb3Y4WTB2TG9iZCszQUozeVNkTjkzSnVMM055N0FMVlFKdWNGVU1p?=
 =?utf-8?B?Y2JNT2tseUQzQ1ZOWnYyVEpvSU5ndG1VL1piaGN2d05lTkNvQ2lYQlI5T2cz?=
 =?utf-8?B?OE96Rk1tcXFTczRLcTFDYVE1TWM0S1BFbG9BdG55SEgyeFdILzQvVmlkZWJI?=
 =?utf-8?B?ejRuTEM0TnBVNUNmc2R1TmsrSzFYTGJ3eU90cVg0UTBaWWkwMEp2Q1JoZ0pR?=
 =?utf-8?B?MGQzSGRkbFpxd3ZkeTJPS2VnRDV5OURBQlMvNUpnbmlaeU1TVkI4TGZnSDE5?=
 =?utf-8?B?cU5yV285OGlid3lQUGxlVms2cHMvYlQxbkk5S3IwaHFXTU1oU1I2eFJ1NEFE?=
 =?utf-8?B?NXhwVGZMUnpFOStLMDJoV2hXNmJ5Y0Zsem5uU1c4elQrdUJiYVhpcFVmUk1N?=
 =?utf-8?B?UmJ4OW94SDB5b3VDVGsrTDRKZERPYjBLT09rdGRvWGp5UUh2RmhqYmp5MDhO?=
 =?utf-8?B?MHpKRnhJK3NDb00xS09weHpRYnFjRW12djFEVkQzbmxFSU44N3p0MElSQ3JY?=
 =?utf-8?B?ZkRqbDdHNGo0cVNtMXFBMGFzNnRVeERUOGZ5ZlBSdW5nSVMwcVMwWTNTTFNX?=
 =?utf-8?B?blliUTBOWE4yNWxnSTMyUEtWLzhIa3FrdUVkZlNpQWxvKytkTjhtVjVKWk9G?=
 =?utf-8?B?dGxvWWxpRDJmb3AwZW5mb245ekVtV1llZy9CalF6NXFQeGJUVWF3V05FSUVS?=
 =?utf-8?B?ZHJtdEZ6c0lLYVkwY3ExYzZvQmhZOGlmcHduZUdZZ2VjRGRuNHlaVU1tbnFa?=
 =?utf-8?B?SEJJUjlGZFVvRFBpbzlxL0dZSDBhNnlPaTJ5ZVBxK0VOb2lUanU0bmVjWldj?=
 =?utf-8?B?M1BOdGs5c1FyQU04TzRoQk1ud3FJRlROYXkxQXRqYkYwZ09xVlZMdFdTRHpr?=
 =?utf-8?B?eTBGTXdCdTlPOVY4NHVuUEZ5RU5Td0phZS9Lb2xHdWJDV0hLeTBOczFzSUFF?=
 =?utf-8?B?aGFHSVBOalY3UFR5Y05OQnh4U0lwNVV0WjQvcmN5R2RTeE5HeWwyUFFycEMx?=
 =?utf-8?Q?rn04AwiRkDYQGDmw=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 514ee3b8-1b24-4b35-33bf-08da12e8614e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 07:30:50.4000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9AzvV5qd6XhJz4s+OKYboJ8im73L1nNFYMOShtrpi+oFRpRXxSFIDGwpuRV26SZ6Sp/ohONM+Ky2JtywSgulr/53sMwPcucDvOh4o8bOCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB7076
X-Proofpoint-GUID: nQDv8aBshWWplDHecsXQ5-bHoSVkjOXx
X-Proofpoint-ORIG-GUID: nQDv8aBshWWplDHecsXQ5-bHoSVkjOXx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_02,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 31/03/22 6:10 am, Sean Christopherson wrote:
> On Sun, Mar 06, 2022, Shivam Kumar wrote:
>> Update the kvm_run structure with a brief description of dirty
>> quota members and how dirty quota throttling works.
> This should be squashed with patch 1.  I actually had to look ahead to this patch
> because I forgot the details since I last reviewed this :-)
Ack. Thanks.
>> +	__u64 dirty_quota;
>> +Please note that this quota cannot be strictly enforced if PML is enabled, and
>> +the VCPU may end up dirtying pages more than its quota. The difference however
>> +is bounded by the PML buffer size.
> If you want to be pedantic, I doubt KVM can strictly enforce the quota even if PML
> is disabled.  E.g. I can all but guarantee that it's possible to dirty multiple
> pages during a single exit.  Probably also worth spelling out PML and genericizing
> things.  Maybe
>
>    Please note that enforcing the quota is best effort, as the guest may dirty
>    multiple pages before KVM can recheck the quota.  However, unless KVM is using
>    a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
>    KVM will detect quota exhaustion within a handful of dirtied page.  If a
>    hardware ring buffer is used, the overrun is bounded by the size of the buffer
>    (512 entries for PML).
Thank you for the blurb. Looks good to me, though I'm curious about the 
exits
that can dirty multiple pages.

Thank you so much for the review, Sean. I'm hoping if I could get 
one-pass review
from you on the third patch in this series (selftests for dirty quota).
