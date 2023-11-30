Return-Path: <kvm+bounces-2972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C537FF43D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:01:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 525B8B20ED2
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E9D654669;
	Thu, 30 Nov 2023 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KDVfgLK4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C2690
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:01:25 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cdd6205e41so1176232b3a.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701360084; x=1701964884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TBtFesakrb+Ah3nRlWp+HFJboe/l0BTz8gE0NQu+vCI=;
        b=KDVfgLK4spVnLBNgJpTDKNHBpn+lE1tfkhlTwYG2RkZiO720s5toq2+zAL2ResZDO/
         +TF12q3wcfRgagUZvye0NHz21+zJ3XKntpDlHMlEHGkhxdJKBwGl0lQPM5rIohvSFwam
         OkE2JRx9drbwXIEvja18YVobgtBv44osizdPUrncS33AcOIr+uDGGo08NNYb0Xzqm9Rr
         gJwmICNbdmYSdPXTGlyWpW6qApJtTyvXJUkHvUwG3eoIwYHMuHPc7QAoZjDRMfPDPsKc
         x8SE6g70RGSLr5e9chw+tq7x2W+Q82ckGgOXBPILT753EBMOuZIiVFW5aMWuJ6kdR8NF
         9Z0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701360084; x=1701964884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBtFesakrb+Ah3nRlWp+HFJboe/l0BTz8gE0NQu+vCI=;
        b=GQ044Unl1ibnHA0w7qBwsWnnayMMNgC6436ENv5WJSCI/ekDGhq7X+wmhJ6lNOylGx
         M7W+7Ia/RfxTaK1rpcnuCZqd4PuxG3k8XAPQcdJba21ZnSMGxEy7cLiA4TNZlYmFTxNe
         f9OhXqoYuYHCU4nh8RVHOO0QdlaQySAIPZJqRRyS5PcANaUMnHRjHJQ0ShKH4y22g4r/
         ATVA4MP5th/a+o6hZBprkYcXNdIC0Qz6KiUk5AEOoa2XyT6c5Oam5tcGkBAPOToRpnef
         uztxyH+PJQTCT/XFvNghJtZ0rjLYqUECijWJ5c8ecpmRz/PCzow+lN5AZl7mbzFolY1K
         kAAQ==
X-Gm-Message-State: AOJu0YzyukBB+EZVgscZMEIGpIdZOhkt+lDzcQ4yEbRWulei19OcsRnP
	w+3dtOMLMELghy7DT4015GCuihQbOhY=
X-Google-Smtp-Source: AGHT+IHi1+aV1vTTHXffZIk3uV4OpjjgxAUEw1/XhdrYnAn5A/NF0XwlraUoBa+fvhAQi1+OPSaHBc3mP7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:21d3:b0:6cb:ba28:b6f1 with SMTP id
 t19-20020a056a0021d300b006cbba28b6f1mr5640398pfj.5.1701360084488; Thu, 30 Nov
 2023 08:01:24 -0800 (PST)
Date: Thu, 30 Nov 2023 08:01:22 -0800
In-Reply-To: <45d28654-9565-46df-81b9-6563a4aef78c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-4-xiaoyao.li@intel.com> <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
 <05f0e440-36a2-4d3a-8caa-842b34e50dce@intel.com> <0fbfc413-7c74-4b2a-bade-6f3f04ca82c2@redhat.com>
 <4708c33a-bb8d-484e-ac7b-b7e8d3ed445a@intel.com> <45d28654-9565-46df-81b9-6563a4aef78c@redhat.com>
Message-ID: <ZWixXm-sboNZ-mzG@google.com>
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Peter Xu <peterx@redhat.com>, 
	"Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	"Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?=" <berrange@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>, 
	Claudio Fontana <cfontana@suse.de>, Gerd Hoffmann <kraxel@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, David Hildenbrand wrote:
> On 30.11.23 08:32, Xiaoyao Li wrote:
> > On 11/20/2023 5:26 PM, David Hildenbrand wrote:
> > > 
> > > > > ... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)
> > > > 
> > > > Get caught.
> > > > 
> > > > > This should be factored out into a common helper.
> > > > 
> > > > Sure, will do it in next version.
> > > 
> > > Factor it out in a separate patch. Then, this patch is get small that
> > > you can just squash it into #2.
> > > 
> > > And my comment regarding "flags = 0" to patch #2 does no longer apply :)
> > > 
> > 
> > I see.
> > 
> > But it depends on if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE will appear together
> > with initial guest memfd in linux (hopefully 6.8)
> > https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com/
> > 
> 
> Doesn't seem to be in -next if I am looking at the right tree:
> 
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next

Yeah, we punted on adding hugepage support for the initial guest_memfd merge so
as not to rush in kludgy uABI.  The internal KVM code isn't problematic, we just
haven't figured out exactly what the ABI should look like, e.g. should hugepages
be dependent on THP being enabled, and if not, how does userspace discover the
supported hugepage sizes?

