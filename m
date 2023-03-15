Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9026BA675
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 06:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjCOFDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 01:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCOFDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 01:03:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6FA12075;
        Tue, 14 Mar 2023 22:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrYsiRy9Tzv4P/ZtNWDQcUn3tqfRf/7B8DFmONsTmVd3SoZ/rmpf/QPLIpwL29/GotI8HALI+FJF74TfIfWiKOXKX5WDvyzx8Q4PpkZwdv4gOZVyWvhRziNPGmJrJsqz8NwhSSWxHowmX/4yAeUIpNpHkyaAiLfnhhSOsC5sfp2a+knqeqaoS2DosFzog0qL2/EXd7PyctpJfIYWRWERlhOCY/GEEESUeWKz3k40CeQ78/P+ApVLb14oZ4WGjl4Gc6O/wc7Z9+FIyampHTYW1e6Dbl0SMgcyGCsO/PyUguUZLV6WAMHeqDx7E5oplVAlSUteLADMf0hXAqWFcILVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FT8EAvph0Et8GBpDF9s13Nldm29VIwrmHW7c6COPDKw=;
 b=l8GrJBY/Y1Q61zFTPTjgObKi/3o4qdUcL7UcEAsZDIkalMCwNkMPKNi5kbzgxh+m9MTQ5rYUT1UBLX+zrEVljwT/MlwypqWOwckXC4175DN5dgPOHFFR4DAldwVmwhvuuZ0O2h80DLib4lVFUPnOVswzRvBmPTAo7or52pVoDCnyEgWiPF27LZ/TOx7GlXCigKbYeT2ID9ejezCp90GjTu/25jUjdAJ14malS1RlfD0EkEWVXgwAyNu5tVHILIelDtzxf0pHaqmFcK72JM4GuX/JqZ2Pz2fIB3z1bNnYxZNaPlTCePIuZtmvJ7VcPu6dxsEydlFaExc264JpD3R4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FT8EAvph0Et8GBpDF9s13Nldm29VIwrmHW7c6COPDKw=;
 b=dUBmoPKxu+oNDNFc9sOrWYdH3DGL8GmyfbUQSDZrBA+DtbaNkM2a/1pkiqsVR2aswjc3X5mTnjKzupu0lrN9q6TWLMCKe//IqC1H4Pr4GKyUCb15lJKPI7q7Gsivh+w6zNXz+KQta+DBPFDO1HnYHHvPlRzHnpsGJEUGvic7HBU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6218.namprd12.prod.outlook.com (2603:10b6:a03:457::17)
 by SJ0PR12MB5612.namprd12.prod.outlook.com (2603:10b6:a03:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 05:03:43 +0000
Received: from SJ1PR12MB6218.namprd12.prod.outlook.com
 ([fe80::1554:c96b:6ce2:adc6]) by SJ1PR12MB6218.namprd12.prod.outlook.com
 ([fe80::1554:c96b:6ce2:adc6%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 05:03:43 +0000
Message-ID: <786f4d69-85c6-a581-1187-2fe8a49cf7e6@amd.com>
Date:   Wed, 15 Mar 2023 10:33:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH kernel 0/2] PreventHostIBS feature for SEV-ES and SNP
 guests
To:     linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        sandipan.das@amd.com, jmattson@google.com, thomas.lendacky@amd.com,
        nikunj@amd.com, ravi.bangoria@amd.com, eranian@google.com,
        irogers@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org
References: <20230206060545.628502-1-manali.shukla@amd.com>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20230206060545.628502-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::16) To SJ1PR12MB6218.namprd12.prod.outlook.com
 (2603:10b6:a03:457::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6218:EE_|SJ0PR12MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 22ee3af3-eeab-4094-b0c8-08db2512a5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D1TsTKZxTKj8GKfercH2LV28f+bYNdlyTB26ClaJIWw7ml/D3f9wa3iuU/0RyLDJ1iSEJVBYQADtGItVT583CFFFO4mwBWRpjuj5kMBDvG0hCzbaYT8eVgLtV35ajWGLqL1RCK0w2hjFYuo9MLWLCcH4hEZNuPQY2sNrF70krDf3DJsjEhjQS2I3XCOKUuVFU0r4EfTUXd+x1cZiyKRYQXJbJVdTvNpFJMfySY4z6EYDyMY2Tygs5yCO0iL3YZgEY6rJUSOXWkZQlGnAb9B0NJ4A7WBjutIyJehFtNdi4G2L3sJZvR6/6H1KyojSMyNMuTqCZQNBAWrvmSULOst+ghvLCZV6+m9jaghPFVUFY19E4B9sddKgkGg+TpcqwMl1Lo4Q16aYfXcod69JvWNAuvMSk2qHAVpzW9uv4Zjg+gHzZQAidP1VODjKYqhf5dX0jpHHgfbCo4olEpnvFjBpD87XO8IuYtKmovsw8lrQMGhU9zWFy6Wl6YfIxpEZ/AFVmTBmL/8oha40FExqxCTRBVzW5f/nh4m+B6+oFmSRfk2Y0oSOmtogGU4PC4ewBslmBDO5aM+E3ElqrXSYhFyplcYNtLctMjPAAzI2HtxJfTXxH6PDz6/QlGmGwF+mbMQ0mO4xGquZVpwgEmxFApNfjbTqB2LpzooDPNWh4LF1G3WG4oDiVYAqRqGfQdH2iZqukwMJAzebO9sGEOmaylclRhxSQzYfklVzcoRDtJZdA/U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6218.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199018)(2906002)(31686004)(41300700001)(83380400001)(36756003)(5660300002)(7416002)(44832011)(66946007)(66556008)(86362001)(31696002)(66476007)(38100700002)(8676002)(4326008)(6916009)(8936002)(316002)(186003)(478600001)(6506007)(26005)(53546011)(6512007)(2616005)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anRRWCt1bjVpVllPOWtvME1aaUo3ZFBySXhKMnZuRHA2UVQ2SklHSnMvMzdS?=
 =?utf-8?B?RGFZSUg4NGVySnkyMnUxT3ZyZHRlQTFudm1TcU5IRmx5VlJxcVRPMlc0bWtV?=
 =?utf-8?B?Y1JRNVhMQUNlaWxlVGRHc0g2R2ZnMHVXNUVyckh1Sk9TYTNzclo1cE1Fd2kw?=
 =?utf-8?B?OTh3SDFWbzlaQ1RRZnNDNnRiSzhob05oMjBxeHhNWi9VaWI0NWkrMnpDcTNP?=
 =?utf-8?B?Zk8zWkJtUTFjanZxSVgvb3BhMFB4dWMvNkxRMHlXbHJUTUk0ZjZsRTh4MEND?=
 =?utf-8?B?U3dRU2taMzFHek9jS1pzbStwTkpWdTZWVUZoTkh1YmtNUWJtcithRjZxRk4y?=
 =?utf-8?B?Ykk2WFFvSlNZQ29NU2tjMU1PQVVlTFpPNGl4RUlEZTBrcmhHRXhZL2YwVUJ0?=
 =?utf-8?B?a3dlRW5NNmFuQXBUUGN5SmRSb0IvdzVGZXFPY1RlbHZEcUw0OTBjUWJDclVG?=
 =?utf-8?B?b0pOOGIvRGpjS2dxNEllWURIdDFPSHRsTktVZWp1YzRmdUN1YkxKTUtCSHRt?=
 =?utf-8?B?UmJ2cHJuZU4rY2M2eEtQQlZSU0tUdG11RVRxWjlDc2M3SUlKRmtsOW1zOXAw?=
 =?utf-8?B?QkdSTjRNNDhISjhrZWJFUGVyVU5CM3g0Nk5OUDZ0dDFpZ2tiUUtTUlR1dE04?=
 =?utf-8?B?dG9BZEdGVXdVNncveFR6clpPNVJINTFGYXk0OWtFUUxUM1pNU1JIb2tRZHh3?=
 =?utf-8?B?bUMyVlRQeC9FYm5abmlLYlVwSHZyY3ZQYjBjMU9NbVVRR2FaVk9iSHg1dDM4?=
 =?utf-8?B?V3Z5U0NHSWRCMnhaWGdtYUxGS2VvR21Pb1MzdkMrRDVHKzJmQTkrVHBDeVFG?=
 =?utf-8?B?MVU0Z3h2NGZHNllTNGwwNjl3bFJwbzZTRGFQSGwwQWdzQUIwV1FpWFFqSi9Q?=
 =?utf-8?B?SGdMd1ZSbTF5Nm1MWWFwUVh6QjBjK3VScmpWSk9uQkp3cFBpQXBjeThIOE1X?=
 =?utf-8?B?Tldud1dZM0htRUo0eUxVQVlHV0htV29TLzVqdm1mZERhVGQ2NTZPWlRGbFgv?=
 =?utf-8?B?RCtTV1YvZkp4LzlrcUh5cVJpMi92Q3pFdFhjUHkwSERGZm1EcTVPNlNrZnVU?=
 =?utf-8?B?Y3BONmRxSzV4aUplU3BDWk5OZCs2Z1V6Vk1LeHo2QWZQQUduaEd6UFVlZW9X?=
 =?utf-8?B?Q2VVZVJrYTVrZlJBQUlydEhEWGN5aFFpS2o3ZlZMVjBEdDNaSDB3elh3WDk1?=
 =?utf-8?B?SjlHWnMwb2kya3BJOVpFWWdmOWtOa3d0NXhZejJnT2w4SUhDdU5vdXhwOUor?=
 =?utf-8?B?RzRieGpReHZWOGFuZisyTlN5UlZYbExYT2xJSTZwZitzMzNXcE5XcHphc3Jh?=
 =?utf-8?B?WTgyaGhGZHd5bGs4UVo2Z3VQM2ZOMDZyOGJIUG96MGE1NHpFOTAraFE0aCtL?=
 =?utf-8?B?WHMxc01KNzBtcnNZQVY1c2k5WUlJajZQMWxkYnI2cEozYW9GVVpzQStVWC9N?=
 =?utf-8?B?ZCtIVGZWaTc0R2RmUEdPb29EbzA3ZnY4YVl3bExURHVQbzk3c3UxeGNuMHFq?=
 =?utf-8?B?VlY1cVdHejBMblZwbkVmRDR6UjBLSlo0VWxhejY3Zk5tdzVSVERkUmZ4TURM?=
 =?utf-8?B?WlgyWTh0YVRKRCtnNkRFaW1FSkFTekpDaE1ObmZMMTdUSGJ6OGRLSEhHVjhD?=
 =?utf-8?B?REQ5a3hZM3JLQm8yZjZkR0EzM0RIU21PZ2FWMWdUdEkxUktUZVlYdW5VWEhW?=
 =?utf-8?B?c0JBa3ZXVUNZdENST2xVRU5GUkkzNSt6Rmk3aHRsS1FMWTJIeW1BZzFNSjl5?=
 =?utf-8?B?Rks0a0Zld1VsK1c4em9BTlUzUlA4MkRVaXgrQkMxUXZvMDI0TjRYUGJUdHNW?=
 =?utf-8?B?TWtrN2NiYXRDU3NoMUdjMktEWnNuQmNENkNBeFZ4MW83TzBDSWF5TVVYeFBh?=
 =?utf-8?B?Y1RNOGZXcnNaYlpCMGVBMEUvMXBuWUJvWkZ0dy9heE4vQ3RLOXlUejNCZm9V?=
 =?utf-8?B?SkwvTGJQM1RDYUpCMHF6NmR6NDVZejluOEl5cXFqZCsreGZqbGwxSldDVkNJ?=
 =?utf-8?B?dk96OWpGM2FnTkIvcUVLajcvSlJXME1MbUJxdkdUMzJiMXhibE9YV3FnRXRn?=
 =?utf-8?B?eVNWcEc2SW5zOVZnZUNZMFlJM255UTJ5YjhOQlIvNjR1WEtsMGNhdDN4TkZU?=
 =?utf-8?Q?Iv7XWz5ocAuiu2dyIKeP0u8gH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ee3af3-eeab-4094-b0c8-08db2512a5c3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6218.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 05:03:43.0145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFOxNaxzD4MmIvRS41XERXfWRK/SQxKk8IXge5OwW2dGHr6O6DcDpn7OINjf/rzYF1PbRDRlUIXhSB47UhpByQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5612
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/6/2023 11:35 AM, Manali Shukla wrote:
> Adds support for PreventHostIBS feature for SEV-ES and SNP guests.
> Currently, the hypervisor is able to inspect instruction based samples
> from the guest and gather execution information.  With enablement of
> PreventHostIBS feature, SEV-ES and SNP guests may choose to disallow
> use of instruction based sampling by the hypervisor in order to limit
> the information gathered about their execution.  (More information in
> Section 15.36.17 APM Volume 2)
> 
> While implementing this feature, unknown NMIs were being seen. On
> further investigation, a race was found effecting the IBS FETCH/OP
> MSR.
> 
> ENABLE bit and VALID bit for IBS_FETCH_CTL are contained in the same
> MSR and same is the case with IBS_OP_CTL.
> 
> Consider the following scenario:
> - The IBS MSR which has ENABLE bit set and VALID bit clear is read.
> - During the process of clearing the ENABLE bit and writing the IBS
>   MSR to disable IBS, an IBS event can occur that sets the VALID bit.
> - The write operation on IBS MSR can clear the newly set VALID bit.
> - Since this situation is occurring in the CLGI/STGI window
>   (PreventHostIBS window), the actual NMI is not taken.
> - Once VMRUN is issued, it will exit with VMEXIT_NMI and as soon as
>   STGI is executed, the pending NMI will trigger.
> - The IBS NMI handler checks for the VALID bit to determine if the NMI
>   is generated because of IBS.
> - Since VALID bit is now clear, it doesn't recognize that an IBS event
>   is occurred which in turn generates the dazed and confused unknown
>   NMI messages.
> 
> Per-cpu ibs_flags which indicates whether PreventHostIBS window is
> active/inactive are added to avoid the above mentioned race.
> 
> An active PreventHostIBS window is set before calling VMRUN and
> cleared after STGI. PreventHostIBS window check is added to
> perf_ibs_handle_irq(), to avoid unknown NMIs and treat them as handled
> when window is active.
> 
> There are 2 patches in this series.
> 1) Add amd_prevent_hostibs_window() function to set per-cpu ibs_flags
> based on an active/inactive PreventHostIBS window.
> 2) Enable PreventHostIBS for SEV-ES and SNP guests.
> 
> Testing done:
> - Executed program symbols in guest are not captured in host when
>   PreventHostIBS feature is enabled.
> - Generated 1000+ NMIs using cpuid command, no unknown NMIs are seen
>   after enablement of PreventHostIBS feature.
> 
> Qemu commandline to enable PreventHostIBS on guest.
> 
> qemu-system-x86_64 -enable-kvm -cpu EPYC-v4,+nohostibs \ ..
> 
> Manali Shukla (2):
>   perf/x86/amd: Add amd_prevent_hostibs_window() to set per-cpu
>     ibs_flags
>   KVM: SEV: PreventHostIBS enablement for SEV-ES and SNP guest
> 
>  arch/x86/events/amd/ibs.c          | 64 ++++++++++++++++++++++++++++++
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/perf_event.h  | 20 ++++++++++
>  arch/x86/kvm/svm/sev.c             | 10 +++++
>  arch/x86/kvm/svm/svm.c             | 39 +++++++++++++++++-
>  arch/x86/kvm/svm/svm.h             |  1 +
>  6 files changed, 133 insertions(+), 2 deletions(-)
> 

A gentle reminder for the review.

-Manali
