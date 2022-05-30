Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA2053798A
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 13:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiE3LFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 07:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiE3LFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 07:05:40 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B183655483
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 04:05:37 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U86uMw026961;
        Mon, 30 May 2022 04:05:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=tLPuEig/JJQHuue+r1A8AsWNtJqUewYNBYDnyB2ak8o=;
 b=2XNRHnxRIPYKF+fDxjtNBJe4U7n9qyR0FfD/qyRN0goieIzYZvbYnmtlie61kyiNHzEF
 zHH92LIAQBvqkLDckn85KLi3BnwH5K2e8V0EoZuYFGMsbDYFmIcMeSApK17MVzV1S6ct
 zQmSuZ4BJs+IN2/Ro2jl9tSZORLrAPJJQr6pyVJ6Gh1SDbuoRXaQSS2spNR8CfRlu7HU
 nwxiPrFYUEStWjHAEQ1UBzQjRmPT7jNqCMTOLG8hjmAhux1JG4kSRaYjEqlF++do0inq
 0AdPVLe9ZnOkgDnrtFOPBlNH9DUqRCK+QR/Q4wPBhfMjKxAZiqdDQWm006OnUgsVcyL9 Kw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3gbk93twvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 04:05:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fq92asFQksZYo4BJd57zMhZ9jGNAmFyJITBJErRFahdqNmtX2yOKn4TvqD2vNPyUctpDcoRgLhIZh+l07GOqpxJNy9cvz7kjWa3gZ7AMugxQbOwurvHXzOspEFiShxkMmkAiw5VgjeyuNS4WOeTCpjTeirELz0L2XNJoWDagUSNQvV5psPYs15+4tk3jYLDhL4puS6nufZJI0NNEIpTz/2GHs2HXdK4svVbTUDhnif+OzCLzA+1Z/RqLVzxIVrandXjxaJRRQMXdG/zfhh8RhqnGZYqazZWnmPfgmmBmE82BeuD094DxnEbE7p0dp5qdDh+PuiWo3RxtUC90uhK5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLPuEig/JJQHuue+r1A8AsWNtJqUewYNBYDnyB2ak8o=;
 b=TpV1plrBbpp7itMNZDuezJMgoNtq3YWK8BzDQy9FwrRvBc9++6nj/av+YRxMzgb/qNXE/OTMkDZm9e1bn7fizqJ5HnByTMzW5vSKYE49yR28Jr5DU7tPqhOhO9jNX47F5PXYk3Gl3YF4J95m8eP0zzkK96t9XW6gwbjjN7/0Fh4vDMMoEa6B4o4AYeG2GuEIHgu4gAPRFhmr51iPN0Zu7aodXYI/Gh8V2p0EcnpBsVHQUZQClkb+O7f6EUkEbM8/IpaplQxdCsxDwrcpp7rp+zGYhFrh8nbu5CEMKGT9pFw2lYBjj8diHAtG45K0Fz9h/qa9mfeReolYtsP8EWwxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DM6PR02MB6875.namprd02.prod.outlook.com (2603:10b6:5:252::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Mon, 30 May
 2022 11:05:20 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 11:05:19 +0000
Message-ID: <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
Date:   Mon, 30 May 2022 16:35:08 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org> <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org> <Yo+82LjHSOdyxKzT@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Yo+82LjHSOdyxKzT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0168.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 256776e3-5b23-4c97-1363-08da422c48d3
X-MS-TrafficTypeDiagnostic: DM6PR02MB6875:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB6875BC89FC62BDA749AE9A9BB3DD9@DM6PR02MB6875.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TsESaxzVwKi9aeykMp4ZcGDRhSAJumsJ+sBhpuRBTI+dfVGTT14JMJN7h7AYdStd9Skg/wQ+STA8tipg0NrEHpGQi8m9q3RF+IVmcKbtujDWRV3eouDphmM/WFWQRlZOkWC0t9i5azqMqJd2m43eCgc19ulO2LB+iDOiSX0A/GrMqmzfpRimdrMXElxa4Uex3vjoAu0wBojysmD92GzOPyMSQc+msWrevCfGu5JC+f6joqg3C6vsi2fb3aTbMPDRAjTjeotk4FlNY5Xio0iSmEMVISJ3/6rpO0CMtYujRps+CK7xc9ViRzNx+bwjdkwCO/MDtvP13WwXfAkWbjd77+M1LSLN8Rtub7ulZ8186+mf5bkNzmrxGJ4H5yRF//EtP0D4m+vSCXkbGejOZORP3MCJX9xsT6h/3V9rJLCjHmmb4/G0VCcf60VmqRXu/jOE8dQm8RS1tzPLvXgZpheBKxg7zBBAOmIJLU7Lu6M0GyYXbq2GMiTYm9zobb7nxKyz66+larQfmPHFLmYNV2TvHId7la+89vd9ysF3XuSFF/LYpjRaqpHXS/eJQKd5xpQx0GA91BcgDhOzfBrDeagPC4NCv9Y/PsHOYix6JFELI4GvjyQwSy3SGZw3+3ZLCDWyuJ47zh4wyUOE9FPB/kktVyh7XhEJuiDp8HOAVfF3C6et0Xj6jTT9m0NPmb3tQrD9vjQeeFGwIZy+BLCa9s0TKUrtbTJgPl5SKwSaYdEN7PvlVbksErqCPyhbOFkehrj4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(86362001)(6666004)(31696002)(186003)(2906002)(110136005)(107886003)(6486002)(26005)(54906003)(6512007)(508600001)(8676002)(6506007)(55236004)(5660300002)(83380400001)(31686004)(66946007)(36756003)(4326008)(2616005)(15650500001)(8936002)(38100700002)(66556008)(66476007)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHJYN092Q3BwWnEyTkVGeHpyb0p1MkhwVWV1LzVSa3hvNFJLbVhKVndGTEFN?=
 =?utf-8?B?L3VSZ3RSVnNVbDcxRkQ1aGczOFhGZGQzbU5TSGJRTHN1OTNwNXliZ0x5Q3Zp?=
 =?utf-8?B?RHQ0dFd6eEU5SlZDMnBGak1CcFQrRDNDcVpObU0wV0hwRFR2d0lvQVdCK0tp?=
 =?utf-8?B?d2c2ZVBNUVVzeERBc2RWaWhzUnJvTUxRWFduNXpzVW9wWUxWS2hlZ1NCSlow?=
 =?utf-8?B?ZTJqL3B4UnFVdzdtNjdYc24xRmIvaEpRQnFNam13UlJwZm9walFqcG8wY1Jp?=
 =?utf-8?B?ZTF1RHZWdldzOFJ1YklDbmVJRmVubllCbGVMRnRBdEdKTXZCL1NISEZIcTll?=
 =?utf-8?B?QTY5OEQvWXpvY2MrczlnYVJxeGZKeUNkaUFuNWtGU2Fod3dRQXJJUHhXdUFx?=
 =?utf-8?B?NDRLVnBYMmcvYkNsSUJpRnRER2x2SnVCZWtTdFlZYlhlQ2lZTHMzMGFoYzJu?=
 =?utf-8?B?SElqemFmek42aitmZzVKSlJwRHJYaVQ0YldrTWpzVWI2SnNXTVkwTmt3L2tB?=
 =?utf-8?B?eFJRY0d0TTBaSjVtWDVxNGV0RmdWWENONWROam1wVytZSEhqNWxaMDNycFFr?=
 =?utf-8?B?M3E2QmlkSHlnUzZVRzZibTBBNVE2YW9kTGNyWndrZ1hWMTUxbkZyTE9EZkcy?=
 =?utf-8?B?OU0wVmZ0K09UR1NuVjJBVlRzNG1ML3htSW5yYzJkejFDNXJwR1RCM1ZYbXRZ?=
 =?utf-8?B?SlIveHRvYmZoZS8zbCtpNTRNKzBhdHM4VjNRUkExdkhwc2ZGY1R6L0h3R09H?=
 =?utf-8?B?Nmw1alJJaFEzbHllb1ZRSTBGaVc5OGpMU1Q0Um44WmJvT0xzcWdod1REWWVt?=
 =?utf-8?B?bHRweG5sVXZMODhlYXJsUGt5SUs1eU1zNlJZYUVKU05LV2RkeUltUllGc3Ux?=
 =?utf-8?B?ZXJhcFhlbnQrOHZBdlpiYVhqNHdCOU5HTWJjVzFyb2V3UlFiOG10RkFwdGNL?=
 =?utf-8?B?WFdaYk9SR2Rnc21ZaUNlNEd0SWFHZzAyM2U3amVneHFUbjBKNHRJUFBqYmRq?=
 =?utf-8?B?cS93alB4bmhRbDdOeWpERUdsVTU4bjF5LzZqUGE5cGtsb01PUy9FenMzNXI1?=
 =?utf-8?B?bW5VdjkvSVdGamtoY1dTL3RVRFI5Y29zVDY4VWx6amk0bUlZdHdGcHgwb2l1?=
 =?utf-8?B?ang0cXFjLy95WldlWXdsY3Z6SnZkZ3FTcFk4K28rWVp3eHE2M0krK1QzR05o?=
 =?utf-8?B?WkhZMWNHQVFLK1dNZzlCSS9JLzRSRFpjQUF2aEhJN0N4WVdOQUp5dGRXM0hk?=
 =?utf-8?B?dTNnd2FsSDE5UHovY1J0a1EwcTZqOE41OGpLQTUyVnkrYzNLRUF2a3hPa0hM?=
 =?utf-8?B?UmZadHVuaGdrTmhScC9uOEtZZWNaenh5Q0RWOVJLYTVXNnFwdTAwa2VKR21Z?=
 =?utf-8?B?MURpZmQxNU0rS3lINWFGWGxnZ3Vka216TzJqUlFOSFpwYXFiZzgwUWFnWm1V?=
 =?utf-8?B?OUFxb29mZ2M0ei9tbVF0aVdJTDRabkd3clJRUVZ6L2ZJM2hYdnp5dVFjUC9X?=
 =?utf-8?B?SUN0Y3NqMndRMGlMa2RmbS82MUhPZGUvV2I1ampiRkpTWjNYcGNLK05UaGFu?=
 =?utf-8?B?Z0ZrNWR2Tlp5VHhaUjE0YmpXTG9CRDNZMG1VbGlkcDJoa2Q4QzZ0bE5PRGVa?=
 =?utf-8?B?RyszbHpCQXZkTmF0TWZWcUpBWVhpYWIvU1hha2VFemxsSm9BR0kyZDRTdmYr?=
 =?utf-8?B?ZUtIb1N0UHpSWDJNV3dMcXBCdi9mYVBRWEhHZzFGOFR5TW50eWFWdjNkUDhx?=
 =?utf-8?B?Z3dBZERPZExUOUE0QzRqckRaZnRwdDlDVFVneE9Lb256NmFlS0hDMU8xQmpG?=
 =?utf-8?B?b0Z1UnhNWkgwM0V2eGtrSXQya3JsK1Y1b2xkMkNqODhHbC9MSjBTYmFCZGZz?=
 =?utf-8?B?WVoxTXZnOUtqNWNTcWM0L1RFS052dVJaaEh2Y2VqUDN3Y1ZpWC9MdUY2b3Rq?=
 =?utf-8?B?aGdiNVNFc2ZxK1lFRzdoMlRkQy9jTXVLS21mUTAzQXNSSFZaUDdFazJZU1JW?=
 =?utf-8?B?Y2RDMFQzNzVYNk9wa2I1cnZkNjgyUlNuVlBrbFVSYmxVd1dhbjY0VndFYXQ2?=
 =?utf-8?B?dUJtVzhHc254QkM4TGwwL3RuNGpwSm0reFhJZDVMWEJmNUVQYnBpamxNK0xD?=
 =?utf-8?B?SGhvZWFIbTdTRzc3aFpiT2xTUEp4dGZxaGdocHBLRTJWcTZHays3ZUdFMUZG?=
 =?utf-8?B?MzVFV1daZzRZaFh1YkxQTjQzaTJnZW5hS25UOHhLcHNtY3NETS84RWZ4d0Rh?=
 =?utf-8?B?bVhlaDlaK0JGc2c2NG1OSVhoNEhWbHBmMk5lKzg4NWNMQzZVVHRxNXl4Vll5?=
 =?utf-8?B?TjdIbkREZXlEcmQyZjNFNHhtOXI3OExSajVJdmE1UGt1bjBMZFFkQ2dvUG5Z?=
 =?utf-8?Q?ZT6mJ0h1ynNO3BxQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256776e3-5b23-4c97-1363-08da422c48d3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 11:05:19.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2xWkdI1/8FtBvBXhGzaJaI1ByQdGeqB8gVJmC9Ey7smdTDdtKWC6iTNMjfu1fG10f0c0sYWIJ6r08YAMj8X3vn/z8XKQL7Wc69eCJ6AfX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6875
X-Proofpoint-ORIG-GUID: XH73MusG722QVqBrvk4pcTWeTSoIMVzR
X-Proofpoint-GUID: XH73MusG722QVqBrvk4pcTWeTSoIMVzR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> It just shows that the proposed API is pretty bad, because instead of
>> working as a credit, it works as a ceiling, based on a value that is
>> dependent on the vpcu previous state (forcing userspace to recompute
>> the next quota on each exit),
> My understanding is that intended use case is dependent on previous vCPU state by
> design.  E.g. a vCPU that is aggressively dirtying memory will be given a different
> quota than a vCPU that has historically not dirtied much memory.
>
> Even if the quotas are fixed, "recomputing" the new quota is simply:
>
> 	run->dirty_quota = run->dirty_quota_exit.count + PER_VCPU_DIRTY_QUOTA
>
> The main motivation for the ceiling approach is that it's simpler for KVM to implement
> since KVM never writes vcpu->run->dirty_quota.  E.g. userspace may observe a "spurious"
> exit if KVM reads the quota right before it's changed by userspace, but KVM doesn't
> have to guard against clobbering the quota.
>
> A credit based implementation would require (a) snapshotting the credit at
> some point during of KVM_RUN, (b) disallowing changing the quota credit while the
> vCPU is running, or (c) an expensive atomic sequence (expensive on x86 at least)
> to avoid clobbering an update from userspace.  (a) is undesirable because it delays
> recognition of the new quota, especially if KVM doesn't re-read the quota in the
> tight run loop.  And AIUI, changing the quota while the vCPU is running is a desired
> use case, so that rules out (b).  The cost of (c) is not the end of the world, but
> IMO the benefits are marginal.
>
> E.g. if we go with a request-based implementation where kvm_vcpu_check_dirty_quota()
> is called in mark_page_dirty_in_slot(), then the ceiling-based approach is:
>
>    static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>    {
>          u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>
> 	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
> 		return;
>
> 	/*
> 	 * Snapshot the quota to report it to userspace.  The dirty count will
> 	 * captured when the request is processed.
> 	 */
> 	vcpu->dirty_quota = dirty_quota;
> 	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
>    }
>
> whereas the credit-based approach would need to be something like:
>
>    static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>    {
>          u64 old_dirty_quota;
>
> 	if (!READ_ONCE(vcpu->run->dirty_quota_enabled))
> 		return;
>
> 	old_dirty_quota = atomic64_fetch_add_unless(vcpu->run->dirty_quota, -1, 0);
>
> 	/* Quota is not yet exhausted, or was already exhausted. */
> 	if (old_dirty_quota != 1)
> 		return;
>
> 	/*
> 	 * The dirty count will be re-captured in dirty_count when the request
> 	 * is processed so that userspace can compute the number of pages that
> 	 * were dirtied after the quota was exhausted.
> 	 */
> 	vcpu->dirty_count_at_exhaustion = vcpu->stat.generic.pages_dirtied;
> 	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
>    }
>
>> and with undocumented, arbitrary limits as a bonus.
> Eh, documenting that userspace needs to be aware of a theoretically-possible wrap
> is easy enough.  If we're truly worried about a wrap scenario, it'd be trivial to
> add a flag/ioctl() to let userspace reset vcpu->stat.generic.pages_dirtied.
Thank you so much Marc and Sean for the feedback. We can implement an 
ioctl to reset 'pages_dirtied' and mention in the documentation that 
userspace should reset it after each migration (regardless of whether 
the migration fails/succeeds). I hope this will address the concern raised.

We moved away from the credit-based approach due to multiple atomic 
reads. For now, we are sticking to not changing the quota while the vcpu 
is running. But, we need to track the pages dirtied at the time of the 
last quota update for credit-based approach. We also need to share this 
with the userspace as pages dirtied can overflow in certain 
circumstances and we might have to adjust the throttling accordingly. 
With this, the check would look like:

u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
u64 last_pages_dirtied = READ_ONCE(vcpu->run->last_pages_dirtied);
u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;

if (pages_dirtied - last_pages_dirtied < dirty_quota)
	return;

// Code to set exit reason here

Please post your suggestions. Thanks.
