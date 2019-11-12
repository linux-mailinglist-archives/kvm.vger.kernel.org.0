Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB9AF9302
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 15:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKLOty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 09:49:54 -0500
Received: from mail-bgr052101135077.outbound.protection.outlook.com ([52.101.135.77]:47872
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbfKLOtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 09:49:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZ0yWjZIirY3IXnZRQLVKriFTVk9HdgsP//T2qYD9UCs68sWevRVhyF3EQW6PobL92aA7VQUFvFwphC0cqg9J8nBFNnKBm0x3Yq5YsIQlIfMT9Cx6/6yOcvTKhpjAmVfx9BuiuT+Yp0743YEToxSZaxF6DtnGxkFdS64Z+dLCyAyW21B/TGnvjI7YbgfPZ97yr5tGQDCQgl4pyVG1dr5RSJq8o7lTxUDRDqGZ0Z0gubiTlrqZPzz8C5oZN/VB+DdSsJTqhR+dszrm9QJqncvIbewtm2utkdvBl//w5JDmfWJ96IKP+XhkMBVnaRtuYmGD9qSfLcp+weLptdpd5WpHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQXpvlGi5daoBtmV2MLrMW0+kGLqOLnhiVf09Ppd3Dw=;
 b=ftJpvcPjCvRxUelia99f0pNK1vreMCxqxoTO3O0FuMyswY5d27ZcxtW8BLkHr4YDrQSoQVRvXqHilIEutDLTTva/sA7ZxDyAsTT8HcuT58BBTAFNU9N6+c2USWztYTUiR1GEqU6xHogrEMRubDFOpm/1+ILJVBWkYf4+ikeiPxjOOvssMwE7920cy0ng7ZWnVtf1UuTl5iSQTWMe3X3RGunLhl4wIQUysw6SkLnjGUvOc53PIQGOPoZWDIe80dSdRZ2QbVnHrkuogRYJH7ioz2bGM/+bTNkG9rkXOlnr+yjBW7yIrMjzMb0NBYjAbTHWUCbcgpnsnyaSUuerRBOT3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQXpvlGi5daoBtmV2MLrMW0+kGLqOLnhiVf09Ppd3Dw=;
 b=JfqpNI2TzK40tjhGzH8DzGLuSH/YpobGOTcG5B5xOsiRH3asFP+G6SnwvsEpx7Yq1XVeg75N4FhK2Qbv7CYEpTujxbFLxhhKAo3TWCcw3IqTTcIQUt5oEJr7oNpYsnv3II5rKmJ6Jwag3cViXgR2vMMuTx4plBkZ5+9rKidme40=
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com (20.178.80.22) by
 VI1PR08MB3471.eurprd08.prod.outlook.com (20.177.59.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 14:49:47 +0000
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::9465:ec66:befb:e8b5]) by VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::9465:ec66:befb:e8b5%3]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 14:49:47 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4] target/i386/kvm: Add Hyper-V direct tlb flush support
Thread-Topic: [PATCH V4] target/i386/kvm: Add Hyper-V direct tlb flush support
Thread-Index: AQHVmQooMjAMF4hMsk+z5W7t6cZOKaeHnsGA
Date:   Tue, 12 Nov 2019 14:49:47 +0000
Message-ID: <20191112144943.GD2397@rkaganb.sw.ru>
References: <20191112033427.7204-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20191112033427.7204-1-Tianyu.Lan@microsoft.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   lantianyu1986@gmail.com,
 pbonzini@redhat.com, rth@twiddle.net,  ehabkost@redhat.com,
 mtosatti@redhat.com, vkuznets@redhat.com,      Tianyu Lan
 <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,     kvm@vger.kernel.org
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1P191CA0004.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::14)
 To VI1PR08MB4608.eurprd08.prod.outlook.com (2603:10a6:803:c0::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e13e0db8-9943-4e42-33b3-08d7677f9000
x-ms-traffictypediagnostic: VI1PR08MB3471:
x-microsoft-antispam-prvs: <VI1PR08MB347147F8A0F3067B83A1A8C0C9770@VI1PR08MB3471.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(376002)(396003)(346002)(39850400004)(366004)(136003)(54094003)(199004)(189003)(6246003)(5660300002)(5640700003)(478600001)(14454004)(6436002)(4326008)(25786009)(6116002)(229853002)(36756003)(66476007)(3846002)(9686003)(6512007)(66556008)(66946007)(2501003)(6486002)(64756008)(66446008)(1076003)(446003)(14444005)(99286004)(486006)(256004)(81166006)(71190400001)(71200400001)(1411001)(11346002)(54906003)(102836004)(26005)(66066001)(52116002)(8676002)(476003)(8936002)(186003)(2351001)(76176011)(386003)(6506007)(33656002)(86362001)(2906002)(7736002)(1361003)(81156014)(6916009)(305945005)(316002)(58126008)(30126002);DIR:OUT;SFP:1501;SCL:5;SRVR:VI1PR08MB3471;H:VI1PR08MB4608.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-transport-forked: True
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELCLHyOfVzOvDwbmLRdcmpPKnhZxNrOf9t+ZaitBLXaNd3iO6iYZ7tbw1upCdON3a58qPdlxXXj10+JIOQ3K7VTM1CWcoZZWn114sOK3KFjRK8u8rLRtgIzk2fGLRPQRtMYkAlJoRY/mrqGkcOhZKPUJwsW5cQPfC7jdJVXjqi7n/E9LpV3WKe7qRdFl/M/x5ZRI7UtplsEd0DP0+pNuNEG9KLv9hl5xdDbhmvHxY8jY4/RHQz7HGKPoZv6+q3Vc2TGKGNHo2GJ+ppjvr0A6JCDpR8JrH31rmk1Uwi6mQ+HJmktG6TrARJ9iBrS+PAwxDxr62vLduRBbLO2l9Cj9dUboPdC8YwfLSdOzLr9C9koIRiR7nYfdN4ncsFt6LD01
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB96B3B89FB7624FA45598987B45EF63@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13e0db8-9943-4e42-33b3-08d7677f9000
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 14:49:47.4052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4e3DEayglwleibheiFvthRQEoIgBbAIfvrWY9/YW7XHiwDrUoolABIh6P7TEKmv6Rsj27yc6Aa6zTNh5TWdTaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3471
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 11:34:27AM +0800, lantianyu1986@gmail.com wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V direct tlb flush targets KVM on Hyper-V guest.
> Enable direct TLB flush for its guests meaning that TLB
> flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
> bypassing KVM in Level 1. Due to the different ABI for hypercall
> parameters between Hyper-V and KVM, KVM capabilities should be
> hidden when enable Hyper-V direct tlb flush otherwise KVM
> hypercalls may be intercepted by Hyper-V. Add new parameter
> "hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
> capability status before enabling the feature.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v3:
>        - Fix logic of Hyper-V passthrough mode with direct
>        tlb flush.
> 
> Change sicne v2:
>        - Update new feature description and name.
>        - Change failure print log.
> 
> Change since v1:
>        - Add direct tlb flush's Hyper-V property and use
>        hv_cpuid_check_and_set() to check the dependency of tlbflush
>        feature.
>        - Make new feature work with Hyper-V passthrough mode.
> ---
>  docs/hyperv.txt   | 10 ++++++++++
>  target/i386/cpu.c |  2 ++
>  target/i386/cpu.h |  1 +
>  target/i386/kvm.c | 24 ++++++++++++++++++++++++
>  4 files changed, 37 insertions(+)
> 
> diff --git a/docs/hyperv.txt b/docs/hyperv.txt
> index 8fdf25c829..140a5c7e44 100644
> --- a/docs/hyperv.txt
> +++ b/docs/hyperv.txt
> @@ -184,6 +184,16 @@ enabled.
>  
>  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
>  
> +3.18. hv-direct-tlbflush
> +=======================
> +Enable direct TLB flush for KVM when it is running as a nested
> +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L2
> +guests are being passed through to L0 (Hyper-V) for handling. Due to ABI
> +differences between Hyper-V and KVM hypercalls, L2 guests will not be
> +able to issue KVM hypercalls (as those could be mishanled by L0
> +Hyper-V), this requires KVM hypervisor signature to be hidden.

On a second thought, I wonder if this is the only conflict we have.

In KVM, kvm_emulate_hypercall, when sees Hyper-V hypercalls enabled,
just calls kvm_hv_hypercall and returns.  I.e. once the userspace
enables Hyper-V hypercalls (which QEMU does when any of hv_* flags is
given), KVM treats *all* hypercalls as Hyper-V ones and handles *no* KVM
hypercalls.

So, if hiding the KVM hypervisor signature is the only way to prevent the
guest from issuing KVM hypercalls (need to double-check), then, I'm
afraid, we just need to require it as soon as any Hyper-V feature is
enabled.


> +Requires: hv-tlbflush, -kvm
>  
>  4. Development features
>  ========================
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 44f1bbdcac..7bc7fee512 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6156,6 +6156,8 @@ static Property x86_cpu_properties[] = {
>                        HYPERV_FEAT_IPI, 0),
>      DEFINE_PROP_BIT64("hv-stimer-direct", X86CPU, hyperv_features,
>                        HYPERV_FEAT_STIMER_DIRECT, 0),
> +    DEFINE_PROP_BIT64("hv-direct-tlbflush", X86CPU, hyperv_features,
> +                      HYPERV_FEAT_DIRECT_TLBFLUSH, 0),
>      DEFINE_PROP_BOOL("hv-passthrough", X86CPU, hyperv_passthrough, false),
>  
>      DEFINE_PROP_BOOL("check", X86CPU, check_cpuid, true),
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index eaa5395aa5..3cb105f7d6 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -907,6 +907,7 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
>  #define HYPERV_FEAT_EVMCS               12
>  #define HYPERV_FEAT_IPI                 13
>  #define HYPERV_FEAT_STIMER_DIRECT       14
> +#define HYPERV_FEAT_DIRECT_TLBFLUSH     15
>  
>  #ifndef HYPERV_SPINLOCK_NEVER_RETRY
>  #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 11b9c854b5..43f5cbc3f6 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -900,6 +900,10 @@ static struct {
>          },
>          .dependencies = BIT(HYPERV_FEAT_STIMER)
>      },
> +    [HYPERV_FEAT_DIRECT_TLBFLUSH] = {
> +        .desc = "direct paravirtualized TLB flush (hv-direct-tlbflush)",
> +        .dependencies = BIT(HYPERV_FEAT_TLBFLUSH)
> +    },
>  };
>  
>  static struct kvm_cpuid2 *try_get_hv_cpuid(CPUState *cs, int max)
> @@ -1224,6 +1228,7 @@ static int hyperv_handle_properties(CPUState *cs,
>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_EVMCS);
>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_IPI);
>      r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_STIMER_DIRECT);
> +    r |= hv_cpuid_check_and_set(cs, cpuid, HYPERV_FEAT_DIRECT_TLBFLUSH);
>  
>      /* Additional dependencies not covered by kvm_hyperv_properties[] */
>      if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC) &&
> @@ -1243,6 +1248,25 @@ static int hyperv_handle_properties(CPUState *cs,
>          goto free;
>      }
>  
> +    if (hyperv_feat_enabled(cpu, HYPERV_FEAT_DIRECT_TLBFLUSH)) {
> +        if (kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_DIRECT_TLBFLUSH, 0, 0)) {
> +            if (!cpu->hyperv_passthrough) {
> +                fprintf(stderr,
> +                    "Hyper-V %s is not supported by kernel\n",
> +                    kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> +                return -ENOSYS;
> +            }
> +
> +            cpu->hyperv_features &= ~BIT(HYPERV_FEAT_DIRECT_TLBFLUSH);
> +        } else if (cpu->expose_kvm) {
> +            fprintf(stderr,
> +                "Hyper-V %s requires KVM hypervisor signature "
> +                "to be hidden (-kvm).\n",
> +                kvm_hyperv_properties[HYPERV_FEAT_DIRECT_TLBFLUSH].desc);
> +            return -ENOSYS;
> +        }

In view of my comment above, this "else if" clause may become
unnecessary.

However, it doesn't hurt either, and doesn't make things worse, so, if
this is seen as 4.2 material and the general KVM vs Hyper-V hypercall
conflict resolution is postponed till after 4.2, the patch looks ok as
it is.

Under this provision

Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>

> +    }
> +
>      if (cpu->hyperv_passthrough) {
>          /* We already copied all feature words from KVM as is */
>          r = cpuid->nent;
> -- 
> 2.14.5
> 
