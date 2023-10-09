Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731C77BE74F
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 19:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377307AbjJIREK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 13:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344542AbjJIREI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 13:04:08 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B085D9E;
        Mon,  9 Oct 2023 10:04:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mx3Xtq9PDJkbwIdAnamtobImOQO16Xq6wLWdVqOEkfGfu595LY086ctfVIkHarwqRnpYc4vXJ0gEkf5bDpszV3VXRDrdeMahBaRW6tKUWIqUKkJkiPfE7IeptlXwH6EBTjNruLGZCZZnGhYk6Ve1dxfwszkCw3NdKjCHvXwIMgeE3D3Zf1UxA3w7EcnzfCfQEQDfbUVA08OX8wNx21PzUeNRs5a1hUsY/KMv922lpvKz3qNjHevWfvVMk0KTSQ2cd0LNQ/at2aKCDGi4BgwP1LRyZDfK/ItmZyXVMSIrNuBc/qsfRP9NSRmCqBYtQ8aS6XAtwXlr/jb5o92aF3rZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWSJCpVVqJ70JCSNoBlRL8IWgIRxqiTdG2BAEBovVKk=;
 b=Mq8AgTGZH3o3OgE2Ya/JDdzP//Uydi0bWug0zzwAVVYX1KVAzQdrO4aJOr3F/74XAwnQuhjWa96FJk5Wkbz7Ew0YFDlV44WGCkrwApZzZnP883mwvY7sremdIX6AtHC8mjromupOI124yc0P0+TgLvVXM1PZvwZJ3mi4DFNZCcwDBwBrlNFpz4oluM35cB44tefebrUqaVeleJ2nrGbT42/TExVUih1b80/NMqqaPI8mGXYPGlP3Ebxk7pEvQLw9fsVmF3hQox83O2cug1kY2w0L7ab31DNsdvpq7nYTv3TlCTDeRKaxPyhh66SwlpKxS6kef38eEvby95vaCdD8kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWSJCpVVqJ70JCSNoBlRL8IWgIRxqiTdG2BAEBovVKk=;
 b=E2YoLzDqgqfXy65hHG50zmvagBu/AijQFS4piIgX1mg+xGlo5VY3aqZjZ7TtDrZ/TwoZOY0ZsUoVuHgwDlK+lMFw0n+MqCVakErDFG2pgIB4e/09Yjjdf/5aAWlar60T4ShImRkQ/GuT7ke1c6KPRTUx5JwemRUKRC9rciqmeh8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 PH8PR12MB6913.namprd12.prod.outlook.com (2603:10b6:510:1ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.42; Mon, 9 Oct
 2023 17:03:59 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::2d00:60c4:e350:a14d%5]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 17:03:59 +0000
Message-ID: <03b7da03-78a1-95b1-3969-634b5c9a5a56@amd.com>
Date:   Mon, 9 Oct 2023 22:33:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
References: <20231002115718.GB13957@noisy.programming.kicks-ass.net>
 <ZRrF38RGllA04R8o@gmail.com> <ZRroQg6flyGBtZTG@google.com>
 <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com>
 <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com>
 <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com> <ZR3hx9s1yJBR0WRJ@google.com>
 <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com>
From:   Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0122.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::8) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|PH8PR12MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aa2bd0d-8195-4940-0515-08dbc8e9bb0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0FP+dmRDKv/hHi8QUZNQg3I3Co0CisD7l1tK3IUN/pXkMNbrnApbHJZwTvPr4C53IEgdP7qNFGZyzXBbeQWQ2tquDEbHUqKV8NU/Arv68mZhzJ0QQLNZpRXae1q9K0Q7+NXTDsN6TbAX8DWB9NqL2Fx5IB9EY/l6e55VWsjwiQhWOdP8VS9uKN06ixQQdyCZu0+vvI8CHnDMHOdfvMy9tZ8E0RRohZib+6Bai1vGU4FKFXnBVMiQRK9bdMCoJSSoTp2by6TsI2I6qvZ2XiZMc6v8Gxq/CU3bQx1xaVmnN0EzaGWzorCyVvfZSZgaA+3uDKkKYxPc7d9egdvvfQOOGz11ZG01I22aBaIMXqWexqLwQOWh4NQzBoaRDounNaVuYBZImgm/wUTTXBFsMZlep2kLTeqxUcNQQB71tCEn0SUHMD3X5oPaO8vlOBqVJqoJz0+GsJZ3hXYproP+JajmOKSlbZOyoBMauhaGByYUmTnedHp/+81zEfrJiF5wxurzBJ+QzDEjVo4Xvd+vbK4e8v2/6TBciH4YR8fUbCWitqfgS0W7U1ofh1zrNE/6A763mmrPzbrUl8UfgbbncMuZAiZ1mvl8mK6274VB/QoggKxT6yDMTAS6nneRVwIxcmXrbGRJbC/XUgkgOvYr0rzcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(366004)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(31686004)(2616005)(26005)(53546011)(38100700002)(36756003)(86362001)(31696002)(83380400001)(6506007)(8676002)(2906002)(4326008)(7416002)(6512007)(478600001)(8936002)(6666004)(6486002)(44832011)(5660300002)(41300700001)(316002)(66476007)(54906003)(66556008)(110136005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU9XdFVWanEvNVR2TEVMMTAzRkhSWVBYVmRrcUpheWtmVklXUTRlSldBY2Vq?=
 =?utf-8?B?R1FsTmxUNzNOSjA2dFl6K2dMcjg3N0Z6Nk1pSzcxV1laUTZURnVNNjNGU2U3?=
 =?utf-8?B?UjRBanVnamcwUE1IcEcvWWxqeFNwV3QrNG02OWV3cDRNN1lxSEFGMGZMTzZK?=
 =?utf-8?B?cDVacUpiM0RUaUxUVnMyejlCV3hHTkoxb0NMc1d1TXl5Q0FrSk15S3ZVblE3?=
 =?utf-8?B?T3hVWGwzYmJOZlR1Q1R3UFg3Y29COHZYUTNiTGdtTjZrMklUZnplRWpyK2VE?=
 =?utf-8?B?SXNEWVdKTmM5emxtNTYxUmNHbVNxMnQwSStrdmwxQlF3ZkZFTFRZOTJscndk?=
 =?utf-8?B?WDA0Vm8zUVdLblBQN0thcStkbDE2Zm5UU2QyT1BGcC81RE1SVHJyUm9RWHN2?=
 =?utf-8?B?ZlJ5TndXMnZ4RjRhUkwwTlhkUWJibHB2K1FtMnpNcFkzSkR1Z1Bib2YyMHBo?=
 =?utf-8?B?THVBcUpBWnk1TXBYemt0YVc5d09RalEwTUlBcXk2TFN6RFFRY2RGRnJmL0lH?=
 =?utf-8?B?UHVzdnk1Zk5UaEVLSTBrTERja0RabkZ0K1E4Z0tpUEVHanNoQnZ1NUFobktQ?=
 =?utf-8?B?L3Zua0haUG50N1BNS0JFUEZwd1hHRkZWQUIrVnV4QlBYeTUxZWlneVJBd2FG?=
 =?utf-8?B?MVp0L1o0cUk5QmJBWmhiMHltdWRKdlpKeUNHRjJJMzlSaG5OeURRNjBOTGs5?=
 =?utf-8?B?UXpnNUV4dzVFMUkzUnQza3llbjZONXVSVUQzOXFVVHdrT1hVNnhpbjZjVTJt?=
 =?utf-8?B?SnZxdnFhKyt4a29VVFZaWGpBSVhpL3BvaFBLYzhJdG9SMFFJdGZZeHBCMUVq?=
 =?utf-8?B?UjE1VmxsalNHL3BxWEJGeW14L21xd0pwM2RubXJ0bHlLSzBVbjlwcHd1YmdM?=
 =?utf-8?B?OEUvckNxN2Ewb1JPaGUxazlOTjRTOUdRb3p3Y0tYVWRKZXpTcmZyVjhONUVw?=
 =?utf-8?B?ek9VRHJtTndhb05KZVNnY2pXOXVub0drdHJqRWtQYjdoOENtdzUvcktDSXJF?=
 =?utf-8?B?MWN3R3l3RWk4SVMyL3Ywd3lLbzZpYkZCOTY3UktsamViT3dhbkdTNmpQN2pJ?=
 =?utf-8?B?Z1Zad1huNWpRUzYxZGJkUWtxWUxBb3FlbWFJTkNLT2RlWStDS0Rkc0ZyQnkr?=
 =?utf-8?B?K1hOTGZxQmxWSld6Zm8wajBYQnphVnUzSEtKTjZpNVQrTmh4OWlmSmwyQ1ZJ?=
 =?utf-8?B?Q3NkVHY4bEtiWGppUmFEcWx6RW1XalkwenE4MDZFYlFQVkx2Z1dkdVNFU3Er?=
 =?utf-8?B?R0tLZytaUHM5L1FrN1kxTlczTmUzL0lHbUVXT1BzUXRlMWpMUmZWSHFzdU56?=
 =?utf-8?B?ZGhERGVTdWk3eHVrR0pzRnJWSzZXbFZXS3o5d0xVSXR1THRtU0s4QlduVmg1?=
 =?utf-8?B?Si9pVTRsUWhRYkJOWVV5ZUl3alF0K3MxL2JoRCs4akVDUm1BbU9mUWl0R3pE?=
 =?utf-8?B?ck9uU0pOMXdyT3ZKSVVvamkrZU9zUHozcDdLVnNxUTAxL2xWN3gwMXp3M2VW?=
 =?utf-8?B?ampROW1LMncyb1V6ZWRUT215MVp3VDFZMi9aN1A5TnJpcFU3YUxNSTJnRjRT?=
 =?utf-8?B?ZTNXRDJzOUdyaTNMYjEydHBEQ0h3d0t3SGxocGRWOVc2LzFaeUg1cHo4UDRk?=
 =?utf-8?B?VE9pSWlaZlVmTURyZ3U0dEN1U3RyZytIOXZ3NnUrL3Q0bGtZMEs1OVozS3Rz?=
 =?utf-8?B?T1lRcEMrSlEwSGcwSkZPNW1sTUYxODByUWNTRnNWU2gxV3Z1S05meU91OUQ3?=
 =?utf-8?B?aHdBdDNRQjF5MllLZ0xsK282ZUwySkN3c2ZMeXB3UTJDSkJmN2I3ZXdjeGpJ?=
 =?utf-8?B?Mm43NEJTODNRZVZKL0FQMnV0S1ltYTlybHRWZ3UyWkQwdFVKaUc3MnVTaTFQ?=
 =?utf-8?B?V2gwTXZydlEyNUZIMDQ0Q0owTnRnM0g4VkhFWEVFNFROb1pWYnNlZVkvRlpK?=
 =?utf-8?B?dGtnTzlVZzNuQms3YzlFRWU5S29TczloMXVYcE1ScjNRbytqeC9Fb1dMOUhS?=
 =?utf-8?B?MVd5SE5aZ2RWQUVxSURaV2ZKdDkvblV2c3RtWmhQNGI5czlSZXVvSjVzVTV0?=
 =?utf-8?B?ZTNCUGZjWHc3Ylc2MUxxUDdmRTdzL2o1YjhmazdhWTl5R0liWkRlQnNTbUpl?=
 =?utf-8?Q?BDCEnJkx4iGx5aRxvbnKbG7LA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa2bd0d-8195-4940-0515-08dbc8e9bb0e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 17:03:59.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYhO99rq4RjncTF/tA1zxS5/vgfrvSK/SP325gXLEzAvkOZqM+Be9YYX7TcHSLz0sq+evqy6tWs7qlXqjJQoLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6913
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2023 3:34 PM, Like Xu wrote:
> Hi all,
> 
> On 5/10/2023 6:05 am, Sean Christopherson wrote:
>> So I'll add a self-NAK to the idea of completely disabling the host PMU, I think
>> that would burn us quite badly at some point.
> 
> I seem to have missed a party, so allow me to add a few more comments
> to better facilitate future discussions in this direction:
> 
> (1) PMU counters on TEE
> 
> The SGX/SEV is already part of the upstream, but what kind of performance
> data will be obtained by sampling enclaves or sev-guest with hardware pmu
> counters on host (will the perf-report show these data missing holes or
> pure encrypted data), we don't have a clear idea nor have we established
> the right expectations. But on AMD profiling a SEV-SNP guest is supported:
> 
> "Fingerprinting attack protection is also not supported in the current
> generation of these technologies. Fingerprinting attacks attempt to
> determine what code the VM is running by monitoring its access patterns,
> performance counter information, etc." (AMD SEV-SNP White Paper, 2020)
> 
> (2) PMU Guest/Host Co-existence Development
> 
> The introduction of pt_mode in the KVM was misleading, leading subsequent
> developers to believe that static slicing of pmu facility usage was allowed.
> 
> On user scenarios, the host/perf should treat pmu resource requests from
> vCPUs with regularity (which can be unequal under the host's authority IMO)
> while allowing the host to be able to profile any software entity (including
> hypervisor and guest-code, including TEE code in debug mode). Functionality
> takes precedence over performance.
> 
> The semantics of exclude_guest/host should be tied to the hw-event isolation
> settings on the hardware interfaces, not to the human-defined sw-context.
> The perf subsystem is the arbiter of pmu resource allocation on the host,
> and any attempt to change the status quo (or maintenance scope) will not
> succeed. Therefore, vPMU developers are required to be familiar with the
> implementation details of both perf and kvm, and try not to add perf APIs
> dedicated to serving KVM blindly.
> 
> Getting host and guests to share limited PMU resources harmoniously is not
> particularly difficult compared to real rocket science in the kernel, so
> please don't be intimidated.
> 
> (3) Performance Concern in Co-existence
> 
> I wonder if it would be possible to add a knob to turn off the perf counter
> multiplexing mechanism on the host, so that in coexistence scenarios, the
> number of VM exits on the vCPU would not be increased by counter rotations
> due to timer expiration.
> 
> For normal counters shared between guest and host, the number of counter
> msr switches requiring a vm-entry level will be relatively small.
> (The number of counters is growing; for LBR, it is possible to share LBR
> select values to avoid frequent switching, but of course this requires the
> implementation of a software filtering mechanism when the host/guest read
> the LBR records, and some additional PMI; for DS-based PEBS, host and guest
> PEBS buffers are automatically segregated based on linear address).
> 
> There is a lot of room for optimisation here, and in real scenarios where
> triggering a large number of register switches in the host/guest PMU is
> to be expected and observed easily (accompanied by a large number of pmi
> appearances).
> 
> If we are really worried about the virtualisation overhead of vPMU, then
> virtio-pmu might be an option. In this technology direction, the back-end
> pmu can add more performance events of interest to the VM (including host
> un-core and off-core events, host-side software events, etc.) In terms of
> implementation, the semantics of the MSRLIST instruction can be re-used,
> along with compatibility with the different PMU hardware interfaces on ARM
> and Risc-v, which is also very friendly to production environments based on
> its virtio nature.
> 
> (4) New vPMU Feature Development
> 
> We should not put KVM's current vPMU support into maintenance-only mode.
> Users want more PMU features in the guest, like AMD vIBS, Intel pmu higher
> versions, Intel topdown and Arch lbr, more on the way. The maturity of
> different features' patch sets aren't the same, but we can't ignore these
> real needs because of available time for key maintainers, apathy towards
> contributors, mindset avoidance and laziness, and preference for certain
> technology stacks. These technical challenges will attract an influx of
> open source heroes to push the technology forward, which is good in the
> long run.
> 
> (5) More to think about
> 
> Similar to the guest PMU feature, the debugging feature may face the same
> state. For example, what happens when you debug code inside the host and
> guest at the same time (host debugs hypevisor/guest code and guest debugs
> guest code only) ?
> 
> Forgive my ignorance and offence, but we don't want to see a KVM subsystem
> controlled and driven by Google's demands.
> 
> Please feel free to share comments to move forward.
> 
> Thanks,
> Like Xu

Hi all,

I would like to add following things to the discussion just for the awareness of
everyone.

Fully virtualized PMC support is coming to an upcoming AMD SoC and we are
working on prototyping it.

As part of virtualized PMC design, the PERF_CTL registers are defined as Swap
type C: guest PMC states are loaded at VMRUN automatically but host PMC states
are not saved by hardware. If hypervisor is using the performance counters, it
is hypervisor's responsibility to save PERF_CTL registers to host save area
prior to VMRUN and restore them after VMEXIT. In order to tackle PMC overflow
interrupts in guest itself, NMI virtualization or AVIC can be used, so that
interrupt on PMC overflow in guest will not leak to host.

- Manali
