Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9E6EEE93
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 23:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbfKDWFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 17:05:06 -0500
Received: from mail-eopbgr20115.outbound.protection.outlook.com ([40.107.2.115]:49027
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389747AbfKDWFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEjqPr3Wk8M/MDjGr2d5zsBiWWxDwcs5tDgq5PqzGSWk8FLOHwrcwt/o/6JmCjr8ULDD6LGjbXz2PnAPoY/gWxVZi2LLx7vGXzcXsTqyC0uzA/KlD2iTdhz9mlZjLpCbGFd5XhxZ1xwWd1JU52s5a86pOSYdZRZUsrdfSb6wwkSIQrvCxIs6Ypidae1QPArF/gDIzF1apWZZd5z/IZ2EK9m6DeiI2yZtCTuU1ysdxDvWCBQEy7XmLkpagZhp38g4JAcC4NhfXV3MD7VeDI/2w1jG0cU3jRMDN0NhQduVlWQB1WTmc8HUn4KkBxcwz4zML++cenVWIG8r8xFi/wH+tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsxOnXwNhhZLnk3IZ4g039Luoz+fkeDHMCiISinkEAY=;
 b=YdxkNlOzYVtdrJgGVeIhxdM2gBCtimvD5zXXtFZfIPUYs+aI+p2W04LFIPtJ2xQ/78nsO/aIYzfGftoqWsSIuojuSKwERjckXogQer4rZk8reCCXBez7uY1/r3YxpzXVq6cJWaQYzqornQ14Bdu5UGU/ffNg6tnibzuz8K+GhSjnianrHfnQHoxiwFTBUPs6dI/fIRHFJmh6v5t2oau1CzXPeq3iPbPtIgDLmA1eyQvVJWdKa9uIZ9aeS48jbzNxCz/EqcSlh/PQ8+CUmKUdcUgoXTrJ3DiQ3D6SR334DF+/+liAqVXHW5vYqXX28MvZcz+TXzMjGlWNmGOBwdGEjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsxOnXwNhhZLnk3IZ4g039Luoz+fkeDHMCiISinkEAY=;
 b=OrkqawgulOvf60DgmwIlARqDTrlqmkm5w49jB5VR88jP91qdpi/A1zq9H5BISpJ9KZsNQSMZ2a2AQL9cOwGf/l9HSWIKPnTrMzEU778dGtWzuSqW6Px7lEqLBXMQOOpmb3xFHSCQJ+AR00KrmGCgkE6ay86IeN9s9RhyHUQS+Kk=
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com (10.172.218.15) by
 AM4PR0802MB2130.eurprd08.prod.outlook.com (10.172.219.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 22:05:01 +0000
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89]) by AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89%12]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 22:05:01 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
Subject: Re: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
Thread-Topic: [PATCH v4 08/17] kvm: x86: Introduce APICv pre-update hook
Thread-Index: AQHVkQWF3SaRgLSvd0GUYdThH7zHx6d7lb6A
Date:   Mon, 4 Nov 2019 22:05:01 +0000
Message-ID: <20191104220457.GB23545@rkaganb.lan>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-9-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1572648072-84536-9-git-send-email-suravee.suthikulpanit@amd.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
mail-followup-to: "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,    "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,    "vkuznets@redhat.com"
 <vkuznets@redhat.com>, "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,      "karahmed@amazon.de"
 <karahmed@amazon.de>,  "rimasluk@amazon.com" <rimasluk@amazon.com>,    "Grimm,
 Jon" <Jon.Grimm@amd.com>
x-originating-ip: [2a02:2168:9049:de00::659]
x-clientproxiedby: HE1PR0502CA0001.eurprd05.prod.outlook.com
 (2603:10a6:3:e3::11) To AM4PR0802MB2242.eurprd08.prod.outlook.com
 (2603:10a6:200:5f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8ce3686-02c3-46d5-f1d0-08d7617309df
x-ms-traffictypediagnostic: AM4PR0802MB2130:
x-microsoft-antispam-prvs: <AM4PR0802MB2130B78E0BC757BF8E7F7930C97F0@AM4PR0802MB2130.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(376002)(39840400004)(136003)(346002)(396003)(189003)(199004)(4326008)(186003)(6916009)(2906002)(6116002)(229853002)(9686003)(6512007)(1076003)(25786009)(36756003)(66946007)(99286004)(446003)(11346002)(486006)(81156014)(102836004)(86362001)(386003)(7416002)(305945005)(46003)(5660300002)(33656002)(7736002)(54906003)(66446008)(316002)(58126008)(66556008)(64756008)(476003)(81166006)(6436002)(6486002)(71200400001)(71190400001)(6246003)(478600001)(256004)(14444005)(8936002)(8676002)(15650500001)(6506007)(52116002)(66476007)(76176011)(14454004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0802MB2130;H:AM4PR0802MB2242.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vwKjLMcFQSRXY0PakzVBeITouWUJMpzmwDmUgfB85bbsDiOZ3Cw6ZRYsCxnWlc+Ktr39qxXZrrqSuc1zD1gfX9wWp/R1xJgc8jR4TP+oTnNYt27nJmfI77z4gBkCVtZ52Tg4vy0eErLQB8U1nsMv+Hs7sC6uE7jZU7XH6NWar0hXVxVLMkKqwaMNxhgkbDhUebZf1DtwLew7LrYE0En5ZQKGPKSggQ63ZDqBWUgEO8AxvZnJvCHhsvNWmKOOws19HBTmzEGMhKu0bVwdsioBGJ4ZWYq/688cw4x2oB/kbs5gecK/KYgGSXddSpwG6ytbAxhaYmwg6gSUhL7a3AcFQZMjdlA8+MLgjtT5yGoN7uvcsqmhK/swY0X2zTZFg++TuSMtRCwGmA0fn0R+tHp8z/6jqaFuc3LNwzUWDzxltbPC66EVYRLLzEak5OsCsSvg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF05B7F9A42AB94BA5C9A0BFF1A7231E@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ce3686-02c3-46d5-f1d0-08d7617309df
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 22:05:01.2578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OmCL6GU0hkxRxQHtFbF3aTfnoqJ51zsFHFVpQQ6h2x8ugWcHLdaCgGfZr4BiLOVlgTZZ0XH3ce7XptZYGlIlxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 10:41:31PM +0000, Suthikulpanit, Suravee wrote:
> AMD SVM AVIC needs to update APIC backing page mapping before changing
> APICv mode. Introduce struct kvm_x86_ops.pre_update_apicv_exec_ctrl
> function hook to be called prior KVM APICv update request to each vcpu.

This again seems to mix up APIC backing page and APIC access page.

And I must be missing something obvious, but why is it necessary to
unmap the APIC access page while AVIC is disabled?  Does keeping it
around stand in the way when working with AVIC disabled?

Thanks,
Roman.

> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm.c              | 6 ++++++
>  arch/x86/kvm/x86.c              | 2 ++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3b94f42..f93d347 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1094,6 +1094,7 @@ struct kvm_x86_ops {
>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
>  	bool (*get_enable_apicv)(struct kvm *kvm);
> +	void (*pre_update_apicv_exec_ctrl)(struct kvm *kvm, bool activate);
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>  	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
>  	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 46842a2..21203a6 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7230,6 +7230,11 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>  	return false;
>  }
>  
> +static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
> +{
> +	avic_update_access_page(kvm, activate);
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  	.cpu_has_kvm_support = has_svm,
>  	.disabled_by_bios = is_disabled,
> @@ -7307,6 +7312,7 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>  	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
>  	.get_enable_apicv = svm_get_enable_apicv,
>  	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
> +	.pre_update_apicv_exec_ctrl = svm_pre_update_apicv_exec_ctrl,
>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
>  	.hwapic_irr_update = svm_hwapic_irr_update,
>  	.hwapic_isr_update = svm_hwapic_isr_update,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4fab93e..c09ff78 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7755,6 +7755,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  	}
>  
>  	trace_kvm_apicv_update_request(activate, bit);
> +	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
> +		kvm_x86_ops->pre_update_apicv_exec_ctrl(kvm, activate);
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>  }
>  EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
> -- 
> 1.8.3.1
> 
