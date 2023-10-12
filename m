Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437D17C6C25
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 13:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347154AbjJLLSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 07:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343826AbjJLLSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 07:18:53 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AD091;
        Thu, 12 Oct 2023 04:18:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tm/mADxlZt4runywogt+FE8ts8BYVvz0I1hVt7trttUeUfFQiVDVPrBlHRc68d+pPr6ki++Qd+CnkaE3w9QKEbLEBeb7FW7/+NX98v30rk99r4qteAFeCntELr7zEsudiGGJvHpASjcQrkNfs0gLOdcd8eQ37qYBdTAPLT31fRB1JZybkpIXPuXcWTZVbVOQeMHHZslvtJjGBkvTqKl41JvXC0pvsXz54sxHvp4djBVtl3t28EQgdSZyEcrJgtIh1D20CdCYnrafb31ABYzu22c+sg0jl4ey1AsF3/U9DDOYH8m3gWVomNIQEH+eiL6URELTuCjGI2xFqsXCs8hvCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMp+BZAbF3XwTRI2K4NZbZkyDRdNeQASZtt5VamOvPs=;
 b=V4wgj+VWq3MmtrsXkbX11x8j0DyF6n4WI/ICJrbY6Tp3zqcMJUiErz5X8ChienVzYwPZwy6RSVUGCFZW0HTPmtU98Ox2R5pI0foTMKO2lY4UC46p08ZqVlPds63/g22gYF9hqex/XRkn2EULyXN8dB/R+hxyH9mJbP2r/KGeGIh6LdEDOrZTCn0Ab+/nGvwWYbeJL5lV13H00Xxxv4Td3q8b3p4r2sioN9xP+WIxobjIMdcYecDSiOShpdOqoXWoxLMEgR6o7+J+A7jax27uj1MNizokG6XGMWltNRrjW3rMBZDN3dcLI1HCOHW1omBlwdhMrf2s/WwqDhVlT50iGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMp+BZAbF3XwTRI2K4NZbZkyDRdNeQASZtt5VamOvPs=;
 b=ACjnxoGVLsTZBcJF76RCrf0s3bW5woRDzeWUDTX9iZI0XKhCO5pTmpnsSTwrcjFMBRUIu5EOK4U1e07xVk0PW4aPa4yZ606l4jxFtLKA7k6EeDKhgKouHrT06myclX7ViAXUz67cj10sMzkO7lWHVi0OCa+1lc/d8rlLJhDm6CI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA0PR12MB8907.namprd12.prod.outlook.com (2603:10b6:208:492::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Thu, 12 Oct
 2023 11:18:49 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Thu, 12 Oct 2023
 11:18:48 +0000
Message-ID: <78322d17-1fe7-4bfd-8073-64a7f0a1b0a2@amd.com>
Date:   Thu, 12 Oct 2023 22:18:27 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] PCI device authentication
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de> <20231009123335.00006d3d@Huawei.com>
 <20231009134950.GA7097@wunner.de>
 <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
 <20231012091542.GA22596@wunner.de>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20231012091542.GA22596@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0026.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA0PR12MB8907:EE_
X-MS-Office365-Filtering-Correlation-Id: 112020a2-c472-43da-82bc-08dbcb150134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: suSryzFqZU/O60YhGH0m4XKqJMPXbctBIDnwzvTmU2iTfHeAFddbc5v2bsYb/+LBDldu9+W2QJxmGNBraHwClYySF6UVEg9Av1OVJFLXIDR7leGTXUeWjanixuPpZniJP425D72BiaNgy58ZA4+Rny5nMLeMtR0A0YfK3Nqu3++lP8Kda9DRBIKfRB16xtAV4JJW7KJtkSfTXu54D0qiFEsp4YfVN20w2bYS6e2yaLC24dD4YrATaGoo7wX4F9bDuUry/oUc9SzryfF4qW4EK2+jE1t1KPd/Eu0d6TnT7sDh6klA7FSBp6A2NexO0PEtZ+HlIklkX6XNOR9lflbMUkJ6lw1Cfv0SBW/+f0mjwL/tlrf0qrjlGajbxeuzFMK8vB8DWZ9viNdP7vFcjOOtvquYlaJVT3FpW8C/LwkMCKYMKBjdTneuG8w1/9kaxbT8vdPoup7eQqMz+DDxaz8RR+5+xBHi+qZz233/7jqxkrU3F6/nUxzBZ2Uvgxx0O54pBGcMADhGKTy0hlDsLtGpSMrTlbVl2z1/PAqiIycghv+yW0mkfeNQXb6ncKSbAiOh9JbbtHQ/8DqPolEQTFgPfS21wh7AhKM1xP9vP629Ax+LbqC+ZNDLbLlsQijmN2Wuwy8rEsPlQosnTNQ457vmBoGrmrsQikPBWwIcmMdbIM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(8676002)(8936002)(4326008)(41300700001)(5660300002)(83380400001)(2906002)(7416002)(36756003)(31696002)(38100700002)(26005)(2616005)(6916009)(316002)(478600001)(66556008)(66476007)(66946007)(54906003)(31686004)(53546011)(6486002)(6512007)(6666004)(6506007)(98474003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzgvZHVmNlA5MWxtdjV1THV6V1BiSUdHT2tQSWtmUWViNS9tWDZSY0w5bXky?=
 =?utf-8?B?aklWbExnMXFwMUVWUlR2RFBBNXp0dEN3TUVwOGtOQTlDV0RSdGtBT3FvenBU?=
 =?utf-8?B?OHgzKzRYN0pUNVNTRGFIbzRsRmJXa3hNYVo1WGhPS2JYRjB4cVRqdFc1eGE5?=
 =?utf-8?B?RWhkMmgrMmtUVDk2VzhnWEhqUlRvTTM1NkVtRlVTV1BaRmhybC8xNGxwY2pR?=
 =?utf-8?B?ZEpLU0pBUkYvOERDcGV2T0dPQndOU3lVYnFPS1lOcyt6VWI5aSs2d0RCMUt2?=
 =?utf-8?B?R1BsT1ZsQ0pkT3RieWI1aUM2cTFMQnVBTU1XajdVclltMmVzczkxMGZIUHl6?=
 =?utf-8?B?bXU0NnlNU29Ec2h5RmdrQlFiVERkZjBqdmpvbDZkdWJ3a0l6RUVFRWNuYzZ0?=
 =?utf-8?B?cmsvSitheVlRZkVqRDFUNFl0eDFUbHY3MFltM1NPbUZkek1tRUdKTlpDVkYy?=
 =?utf-8?B?UHlzRkNiSnM1UXdvNk1MKy8xdGh1QU4xNm8vajlCc01PeUFLSklyZHFGb1lz?=
 =?utf-8?B?QkNLa3Y1V1puUkN0U0NzZTIzYWIzOGtENmxjemkvdEpHL2ZLTCtJRERabDRY?=
 =?utf-8?B?RFBLZC9GZzl3YkNRWTloclIzbGxpMWxLT0FZODBueEhnZG1oS3lQVk1ZU1c1?=
 =?utf-8?B?TFFTb05QMzl0RVJVL1lVOTlCaEtDQ1FXSWNqMTRLa1VYb1N4blBQTEVNbGhT?=
 =?utf-8?B?VFlsZHYybEVIZGd2VEVicUxub0Raam5pNGxDejVSTVp4TVNXZDIwTWlUWDRX?=
 =?utf-8?B?RE45eUNhWllYZDEwMTBFOGxrNUxVNXhndk1NL2lSYXNtR1p5UU91TXYvZVdl?=
 =?utf-8?B?Y1hsRllKd3VkaWNhc3J6eUN5aTA2VTBvOXB3bU80WjBybUNiK01sZ3dOUG1V?=
 =?utf-8?B?NU1QNVhQZXlwV2dQeEttVVBJcmpLZWdTMUhISXUyRmZZTEVvL212eHYzTU55?=
 =?utf-8?B?MldBUUhrMTFrVjZuRlRPZmlha0ZkK1F1Y0RMeERpenAzZjlGd1JiVm5FUUN5?=
 =?utf-8?B?eFVKNTFLZzlZQlVFOGtxNjVGQ3lqR3hxSHNCV3JENXF1OUdqbDNMVitTWTA0?=
 =?utf-8?B?bUVtZVFHMG5kUUVPT1NKYUxSK0lrV2dZb3NHZENFYjVHaDd4amhOWUpOVkhp?=
 =?utf-8?B?MHh4Vkl1aEEwdFhJZUJBUnpDU1o1MVJxMmpFd1ZZSGx4NlFBK2NEbi9TaGZU?=
 =?utf-8?B?c1J0KzdEd0MxSUlZelAxNEFHT25jQVVXRUVCSTJSUFF3RXUyV0NBQUcxTEg3?=
 =?utf-8?B?clZUVnVkTkZ4RWxUSTFvN21kcTQ5V2VtSWRKUDRMMmZvQTBzdDNsL0hQTHhK?=
 =?utf-8?B?V2J5NFpGQlcyOTE3SnBPektYd1Y0dlBnNzJaTzFxdGh1RWlWanZoR0F6eCtm?=
 =?utf-8?B?dmV5NWU1dmVRQTJUMzJQK3R3SmJXVWZqNkpOR2hFTEI1dUU1MU1MSHUyVUJ0?=
 =?utf-8?B?TTRtV05zQmo0UDg2ZkM0Z3ZKejd4K3NKd09URFdnNW0wSTJ3VjBmb0JqNmlD?=
 =?utf-8?B?WjdQMHYxNmU2bVZabkF1RUtwY25FRnZ1VjNEdHJkNS91UVRHYzRJMXdXNkdK?=
 =?utf-8?B?aW5scFFBU1pTVVRPZmlYSzFWMGZDemdkVm1BeU04MVhTaS94MGJCNFVOeWJq?=
 =?utf-8?B?KzREZi9TSmxQcVlxZDBaa0Q1TDQ2aXhBRFp4R1Y1Zi9TUG4zdVZOYWovaTJ1?=
 =?utf-8?B?WnBCam5LSnFOTjFTZVVEU3ZTSlFSclMwWFNzV2tmcC9KY1BpVmcrQ1JZTUsy?=
 =?utf-8?B?NmxPN1ZQRnQ4UEFTTjFucW1VNXdFaHE2VmZ5bnpIZmJFNXdSQmQvNkFDNDIr?=
 =?utf-8?B?Tm5TSFByR0pwRkxzU3JzcCs5ZXZqZ1hwS01EcmVqd3MyMFQyMGxHYjM3TTJN?=
 =?utf-8?B?am9oT0Vxa2lFWGlEWCttSHY4NnJSSlRxdUJQNDJCUnBuWmNDZXVSaXBMeXNa?=
 =?utf-8?B?bGRWRXJqcWlBcloxdys1MVpBUEVyME1zSWlEc0k5TEV3UEwxYVgyL0NCY0Uw?=
 =?utf-8?B?OHMrMDNHUS9WWE9qaktZRjBmNUVqam9EbjVYTUFndGNpOTJudjJVSVA0T3hD?=
 =?utf-8?B?bHFtaEptMitFT0R2OURvSko4V3FqaGtUQklFdVJkdGsxcGF2a0ZDbDMxWTFH?=
 =?utf-8?Q?Kxf/9SjaAhadC2pfg8HXjmllS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112020a2-c472-43da-82bc-08dbcb150134
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2023 11:18:48.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fe8NTZk6lbGLgyTbKgy7njlj5rE+T2UoCb0JM8uL7A4GMFfNzcnRZPR+52qhWD25ogE7mTwDQv+GQISynUGsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8907
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/10/23 20:15, Lukas Wunner wrote:
> On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:
>> But the way SPDM is done now is that if the user (as myself) wants to let
>> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
>> as CMA is not a (un)loadable module or built-in (with some "blacklist"
>> parameters), and does not provide a sysfs knob to control its tentacles.
>> Kinda harsh.
> 
> On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
> *before* it is passed through to a guest?  If so, why does it do that?

Yes, to set up IDE. SEV TIO is designed in a way that there is one 
stream == set of keys per the PF's traffic class.

It is like this - imagine a TDISP+SRIOV device with hundreds VFs passed 
through to hundreds VMs. The host still owns the PF, provides DOE for 
the PSP, the PSP owns a handful of keys (one will do really, I have not 
fully grasped the idea when one would want traffic classes but ok, up to 
8), and hundreds VFs work using this few (or one) keys, and the PF works 
as well, just cannot know the IDE key (==cannot spy on VFs via something 
like PCI bridge/retimer or logic analyzer). It is different than what 
you are doing, DOE is the only common thing so far (or ever?).

btw the PSP is not able to initiate SPDM traffic by itself, when the 
host decides it wants to setup IDE (via a PSP in SEV TIO), it talks to 
the PSP which can return "I want to talk to the device, here are 
req/resp buffers", in a loop, until the PSP returns something else.

> Dan and I discussed this off-list and Dan is arguing for lazy attestation,
> i.e. the TSM should only have the need to perform SPDM exchanges with
> the device when it is passed through.

Well, I'd expect that in most cases VF is going to be passed through and 
IDE setup is done via PF which won't be passed through in such cases as 
it has to manage VFs.

> So the host enumerates the DOE protocols

Yes.

> and authenticates the device.

No objection here. But PSP will need to rerun this, but still via the 
host's DOE.

> When the device is passed through, patch 12/12 ensures that the host
> keeps its hands off of the device, thus affording the TSM exclusive
> SPDM control.

If a PF is passed through - I guess yes we could use that, but how is 
this going to work for a VF?

> I agree that the commit message of 12/12 is utterly misleading in that
> it says "the guest" is granted exclusive control.  It should say "the TSM"
> instead.  (There might be implementations where the guest itself has
> the role of the TSM and authenticates the device on its own behalf,
> but PCIe r6.1 sec 11 uses the term "TSM" so that's what the commit
> message needs to use.)

This should work as long as DOE is still available (as of today).

> However apart from the necessary rewrite of the commit message and
> perhaps a rename of the PCI_CMA_OWNED_BY_GUEST flag, I think patch 12/12
> should already be doing exactly what you need -- provided that the
> PSP doesn't perform SPDM exchanges before passthrough.  If it already
> performs them, say, on boot, I'd like to understand the reason.

In out design this does not have to happen on the host's boot. But I 
wonder if some PF host driver authenticated some device and then we 
create a bunch of VFs and pass the SPDM ownership of the PF to the PSP 
to reauthentificate it again - the already running PF host driver may 
become upset, may it? 12/12 assumes the host driver is VFIO-PCI but it 
won't be, VFs will be bound to VFIO-PCI. Hope this all makes sense. Thanks,


> 
> Thanks,
> 
> Lukas

-- 
Alexey


