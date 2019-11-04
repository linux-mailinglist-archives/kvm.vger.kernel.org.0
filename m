Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBF7EEC19
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 22:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbfKDVx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 16:53:57 -0500
Received: from mail-eopbgr150098.outbound.protection.outlook.com ([40.107.15.98]:54151
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387718AbfKDVxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 16:53:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/WUwH/fAaJhEoyKAhCmFzTeiNCxJ00nWGdb+TV8PybhK0L14iyz8zLIw6JGelqcDHhOguxizGVFgRIciMdevd+CoaKa8U5gf7zGu4vxbxYs+ZKwSyjcU+VGMQlVwKSbex9qa9Y1nFnnFgJ0KingVUAUsene1nDQLh3QXnl6henGKImZK80AOGsLUn/D5P156mv5c0P3KEGWylryPEDiAs8HF6my1U5P7tIU9ZyJ8ZjSGdxLiTx17dVFtkaaF6LLp8N7ZErJcFWbI/W/F7MPD2sa1podHIp+QnVAnYyH+1z6yppMxevPG3YQ6z4UlVPXUcV7uKUeZCykvrf8zSGz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOgmPMTOntPI+NHA29S0OO4RHAPLHt2NIVjM0ZVmISE=;
 b=bBhMmEKbIkOCGnALeNdXSLGRFeSEGXvVHG77lVVsSXxFA0qXvq3n4Z3DcjL1Zw3ZbbPc0IbNH5wiPcbZaVNwka72DXPZEXyB3IQqMppXgbvNnbT1XCkWqMgJ2kcboTqQFELCKaPRjnGTzT/7JuUgKGJXIURI73A5AtGWJ+AZySKUFSCEAAGjuIT8re+V7RT0xsjCLXmMEDbCZ9NitLwmO6ykhc0H/r+4wO8lxe7PEv4qkdlThR3uOm2DEbx5n+knlKVv3jqHi1l4nHS9QybBUZHVmE64oA4t3FCBnkfdJfTkis7pQQNKUAgv5wWvZVvUQHAACSb0T3qLP3JaeQjUMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOgmPMTOntPI+NHA29S0OO4RHAPLHt2NIVjM0ZVmISE=;
 b=OHu9RKPFpNGQIpncykGwHCg6IPFHQimWgqalIvY5Ylieat8XmDPmpfIXiaqVY8e7lvKJK4XduwHyhUBprB5d74ObD9EHECbSmm46AqKHRWl/oHqzjWjwbWIcree2knh6KJtEKPkdm3QEBEWYbe1egofyRUKSZRkGKi1gXqaOAeo=
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com (10.172.218.15) by
 AM4PR0802MB2145.eurprd08.prod.outlook.com (10.172.217.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 21:53:52 +0000
Received: from AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89]) by AM4PR0802MB2242.eurprd08.prod.outlook.com
 ([fe80::9c3e:dc5:e056:9f89%12]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 21:53:51 +0000
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
Subject: Re: [PATCH v4 07/17] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Topic: [PATCH v4 07/17] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
Thread-Index: AQHVkQWEOJKDttGuEk67IxsHyiXMcqd7kqEA
Date:   Mon, 4 Nov 2019 21:53:51 +0000
Message-ID: <20191104215348.GA23545@rkaganb.lan>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-8-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1572648072-84536-8-git-send-email-suravee.suthikulpanit@amd.com>
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
x-clientproxiedby: HE1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:3:9e::24) To AM4PR0802MB2242.eurprd08.prod.outlook.com
 (2603:10a6:200:5f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 261a8482-e093-4903-ca7c-08d761717ad6
x-ms-traffictypediagnostic: AM4PR0802MB2145:
x-microsoft-antispam-prvs: <AM4PR0802MB2145D4F4F3741D832E51FFF2C97F0@AM4PR0802MB2145.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39840400004)(376002)(396003)(136003)(366004)(189003)(199004)(14454004)(54906003)(8676002)(25786009)(99286004)(58126008)(6486002)(33656002)(229853002)(66556008)(66476007)(64756008)(6436002)(66446008)(316002)(81166006)(81156014)(7416002)(7736002)(478600001)(305945005)(2906002)(8936002)(36756003)(6916009)(6116002)(186003)(256004)(14444005)(1076003)(52116002)(76176011)(86362001)(4326008)(102836004)(66946007)(6506007)(386003)(446003)(11346002)(5660300002)(476003)(486006)(71190400001)(46003)(71200400001)(6246003)(9686003)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:AM4PR0802MB2145;H:AM4PR0802MB2242.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wf7XtEyfbg3z83qqozmo007DDzhPSzyJz6SlEynSmrVjOelICYoNWucTsZ3ym9vQ2xxqKjG1JH93JP/km40Q8Rp3rW2zjLk8AlIpFbgkro1MjL53P4GrywtD+r/jW9AzytZlTDUJK1mXdrOKRST1/I3GAQrsdQleY7blSaRvFP7JJpSAkY0KBciEvTAYy6gdIQXTvr9+hhjYZMIPh1Owk9DFF0l5XdNKFSTjHuwwlA2Xp6mRyJkvAd/r7Wa9QNLf/Jpa1wyjhpZhjP7W+wiaXjmEP3xQD+ol8e/qg3U+gYPYwHLN4VN8aw0FbWSOdxh71odCz/9tDjHdiJb8vHuGqEF0uULBPKD0GaY3D2mtBw3nJxPG+dFJR0d+l83IBeI4TI5wu/6KGBLiWX7amE4u0J8OpIQnxbOUrKV5sfVymXeFrUhHMrtDRHFLNsnX21m/
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2D6CE5817CF9840B4D3F6B295E03E4A@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261a8482-e093-4903-ca7c-08d761717ad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 21:53:51.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V7U7OtzekfUor6D6Wgi7XIvuOIQGysHpaYna7bGpLn4lOc1iJc5QB7fQHXcDdEzN4TBMX90LPl4UGiByFSmv5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 10:41:30PM +0000, Suthikulpanit, Suravee wrote:
> Re-factor avic_init_access_page() to avic_update_access_page() since
> activate/deactivate AVIC requires setting/unsetting the memory region used
> for virtual APIC backing page (APIC_ACCESS_PAGE_PRIVATE_MEMSLOT).

AFAICT the patch actually touches the (de)allocation of the APIC access
page rather than the APIC backing page (or I'm confused in the
nomenclature).

Thanks,
Roman.

> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b7d0adc..46842a2 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1668,23 +1668,22 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>   * field of the VMCB. Therefore, we set up the
>   * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
>   */
> -static int avic_init_access_page(struct kvm_vcpu *vcpu)
> +static int avic_update_access_page(struct kvm *kvm, bool activate)
>  {
> -	struct kvm *kvm = vcpu->kvm;
>  	int ret = 0;
>  
>  	mutex_lock(&kvm->slots_lock);
> -	if (kvm->arch.apic_access_page_done)
> +	if (kvm->arch.apic_access_page_done == activate)
>  		goto out;
>  
>  	ret = __x86_set_memory_region(kvm,
>  				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
>  				      APIC_DEFAULT_PHYS_BASE,
> -				      PAGE_SIZE);
> +				      activate ? PAGE_SIZE : 0);
>  	if (ret)
>  		goto out;
>  
> -	kvm->arch.apic_access_page_done = true;
> +	kvm->arch.apic_access_page_done = activate;
>  out:
>  	mutex_unlock(&kvm->slots_lock);
>  	return ret;
> @@ -1697,7 +1696,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	ret = avic_init_access_page(vcpu);
> +	ret = avic_update_access_page(vcpu->kvm, true);
>  	if (ret)
>  		return ret;
>  
> -- 
> 1.8.3.1
> 
