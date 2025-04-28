Return-Path: <kvm+bounces-44577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 368C0A9F350
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 16:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CEC17A3639
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E3F26C39E;
	Mon, 28 Apr 2025 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAayAwQ1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD61B86EF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745850090; cv=none; b=WLjvV+clXt9t1qOaT9gUXp4l3xRrw/M+2AVSsI/yGjRBT6vd/qeqfJ0vvYbkGuLbwd4YX6GZIcTSR+iNS/2JRYH9rQUBbqIeS+XCIyXgXNL2Z+FFj3zvTW8P9chKwEJiM/O9OOqZfyzcMWjtISHu2ETzFU0ZWzt9kjZeyGoOpik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745850090; c=relaxed/simple;
	bh=M/8gKPrj9UzBo44bqxU2ZtRdrkTJFsFYsgFLwZFM444=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzC8uUxHCmm9wcz3uc5pp1FPFW2Bt1nBB6jM/PZhsDHnMxz1WMG0faq/IUbz4HV80ysuAXrPpTyCcO0cBAlzLfD31z74vzRwCtc4LJUaODHYUTd0XMQUpOHsnPVrwJMsYwYhdMX+NeYyTqiM4RZ4OMA5xojSYrXkTAZ2Ys9/xmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAayAwQ1; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745850088; x=1777386088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M/8gKPrj9UzBo44bqxU2ZtRdrkTJFsFYsgFLwZFM444=;
  b=LAayAwQ1vywZtu8wrmcHAhYJLvNO+6ACL6VXAPixa5nJmCO3lIg65mON
   7eDabxWS/AqEqGXCXjVbkvsDtUqmfTmVwVFNfu3XjYiVtImqGoOTzMgj7
   7BVkw6bikycWhZC6gss6N+CLYP3/odJ/wi1Io0nOeEuVK/DEkKWfN1Fn9
   wDKiA80nIuc4h1Slwf++kJ65ZxhbHph94IQ0SI5caY0wkV4qItL5Pp7Hk
   6/5L/lOPcB2EJ1/9LvPtUJoGZwyIVMR4uZr9kivwGDdgrO31JaD5fBzwb
   LUC82f1OV/9qdpKgeYQtb0oZYf6eh4uU1QGNoRUPxGRJncGKKVS9cfR7D
   w==;
X-CSE-ConnectionGUID: k2+LM5PtToCqi8SyaF46tw==
X-CSE-MsgGUID: uVmOF2YVTT+6Pkt3/1aafg==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="69942576"
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="69942576"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 07:21:27 -0700
X-CSE-ConnectionGUID: aui4+n6AQBygx0YSOr8INg==
X-CSE-MsgGUID: zDo3OoVIT7+i4mGbisKf6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="137584568"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 28 Apr 2025 07:21:22 -0700
Date: Mon, 28 Apr 2025 22:42:19 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	pierrick.bouvier@linaro.org
Subject: Re: [PATCH 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <aA+Ty2IqnE4zQhJv@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-4-zhao1.liu@intel.com>
 <87frhwfuv1.fsf@pond.sub.org>
 <aA3TeaYG9mNMdEiW@intel.com>
 <87h6283g9g.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6283g9g.fsf@pond.sub.org>

On Mon, Apr 28, 2025 at 09:19:07AM +0200, Markus Armbruster wrote:
> Date: Mon, 28 Apr 2025 09:19:07 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 3/5] i386/kvm: Support event with select & umask format
>  in KVM PMU filter
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus,
> >
> >> > +        case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK: {
> >> > +            if (event->u.x86_select_umask.select > UINT12_MAX) {
> >> > +                error_setg(errp,
> >> > +                           "Parameter 'select' out of range (%d).",
> >> > +                           UINT12_MAX);
> >> > +                goto fail;
> >> > +            }
> >> > +
> >> > +            /* No need to check the range of umask since it's uint8_t. */
> >> > +            break;
> >> > +        }
> >> 
> >> As we'll see below, the new x86-specific format is defined in the QAPI
> >> schema regardless of target.
> >> 
> >> It is accepted here also regardless of target.  Doesn't matter much
> >> right now, as the object is effectively useless for targets other than
> >> x86, but I understand that will change.
> >> 
> >> Should we reject it unless the target is x86?
> >
> > I previously supposed that different architectures should implement
> > their own kvm_arch_check_pmu_filter(), which is the `check` hook of
> > object_class_property_add_link():
> >
> >     object_class_property_add_link(oc, "pmu-filter",
> >                                    TYPE_KVM_PMU_FILTER,
> >                                    offsetof(KVMState, pmu_filter),
> >                                    kvm_arch_check_pmu_filter,
> >                                    OBJ_PROP_LINK_STRONG);
> 
> This way, the checking happens only when you actually connect the
> kvm-pmu-filter object to the accelerator.
> 
> Have you considered checking in the kvm-pmu-filter object's complete()
> method?  Simple example of how to do that: qauthz_simple_complete() in
> authz/simple.c.

Thank you, I hadn't noticed it before. Now I study it carefully, and yes,
this is a better way than `check` hook. Though in the following we are
talking about other ways to handle target-specific check, this helper
may be still useful as I proposed to help check accel-specific cases in
the reply to Philip [*].

[*]: https://lore.kernel.org/qemu-devel/aA3cHIcKmt3vdkVk@intel.com/

> > For x86, I implemented kvm_arch_check_pmu_filter() in target/i386/kvm/
> > kvm.c and checked the supported formats (I also supposed arch-specific
> > PMU filter could reject the unsupported format in
> > kvm_arch_check_pmu_filter().)
> >
> > But I think your idea is better, i.e., rejecting unsupported format
> > early in pmu-filter parsing.
> >
> > Well, IIUC, there is no way to specify in QAPI that certain enumerations
> > are generic and certain enumerations are arch-specific,
> 
> Here's how to make enum values conditional:
> 
>     { 'enum': 'KvmPmuEventFormat',
>       'data': ['raw',
>                { 'name': 'x86-select-umask', 'if': 'TARGET_I386' }
>                { 'name': 'x86-masked-entry', 'if': 'TARGET_I386' } ] }

What I'm a bit hesitant about is that, if different arches add similar
"conditional" enumerations later, it could cause the enumeration values
to change under different compilation conditions (correct? :-)). Although
it might not break anything, since we don't rely on the specific numeric
values.

> However, TARGET_I386 is usable only in target-specific code.  This has
> two consequences here:
> 
> 1. It won't compile, since QAPI schema module kvm.json is
>    target-independent.  We'd have to put it into a target-specific
>    module kvm-target.json.
> 
> 2. Target-specific QAPI schema mdoules are problematic for the single
>    binary / heterogeneous machine work.  We are discussing how to best
>    handle that.  Unclear whether adding more target-specific QAPI
>    definitions are a good idea.

And per yours feedback, CONFIG_KVM can also only be used in target-specific
code. Moreover, especially if we need to further consider multiple
accelerators, such as the HVF need mentioned by Philip, it seems that
we can't avoid target-specific issues here!

> >                                                         so rejecting
> > unsupported format can only happen in parsing code. For example, wrap
> > the above code in "#if defined(TARGET_I386)":
> >
> >     for (node = head; node; node = node->next) {
> >         KvmPmuFilterEvent *event = node->value;
> >
> >         switch (event->format) {
> >         case KVM_PMU_EVENT_FORMAT_RAW:
> >             break;
> > #if defined(TARGET_I386)
> >         case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK: {
> >             ...
> >             break;
> >         }
> >         case KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY: {
> >             ...
> > 	    break;
> >         }
> > #endif
> >         default:
> > 	    error_setg(errp,
> >                        "Unsupported format.");
> >             goto fail;
> >         }
> >
> >         ...
> >     }
> >
> > EMM, do you like this idea?
> 
> This is kvm_pmu_filter_set_event(), I presume.
>
> The #if is necessary when you make the enum values conditional.  The
> default: code is unreachable then, so it should stay
> g_assert_not_reached().
>
> The #if is fine even when you don't make the enum values conditional.
> The default: code is reachable then, unless you reject the unwanted
> enums earlier some other way.

Thanks for your analysis, it's very accurate! I personally prefer the
2nd way.

> >> If not, I feel the behavior should be noted in the commit message.
> >
> > With the above change, I think it's possible to reject x86-specific
> > format on non-x86 arch. And I can also note this behavior in commit
> > message.
> >
> >> >          default:
> >> >              g_assert_not_reached();
> >> >          }
> >> > @@ -67,6 +82,9 @@ static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
> >> >      filter->events = head;
> >> >      qapi_free_KvmPmuFilterEventList(old_head);
> >> >      return;
> >> > +
> >> > +fail:
> >> > +    qapi_free_KvmPmuFilterEventList(head);
> >> >  }
> >> >  
> >> >  static void kvm_pmu_filter_class_init(ObjectClass *oc, void *data)
> >
> > ...
> >
> >> >  ##
> >> >  # @KvmPmuFilterEvent:
> >> >  #
> >> > @@ -66,7 +82,8 @@
> >> >  { 'union': 'KvmPmuFilterEvent',
> >> >    'base': { 'format': 'KvmPmuEventFormat' },
> >> >    'discriminator': 'format',
> >> > -  'data': { 'raw': 'KvmPmuRawEvent' } }
> >> > +  'data': { 'raw': 'KvmPmuRawEvent',
> >> > +            'x86-select-umask': 'KvmPmuX86SelectUmaskEvent' } }
> >> >  
> >> >  ##
> >> >  # @KvmPmuFilterProperties:
> >> 
> >> Documentation could perhaps be more explicit about this making sense
> >> only for x86.
> >
> > What about the following doc?
> >
> > ##
> > # @KvmPmuFilterProperties:
> > #
> > # Properties of KVM PMU Filter (only for x86).
> 
> Hmm.  Branch 'raw' make sense regardless of target, doesn't it?  It's
> actually usable only for i86 so far, because this series implements
> accelerator property "pmu-filter" only for i386.

The advantage of this single note is someone can easily mention other
arch in doc :-)

> Let's not worry about this until we decided whether to use QAPI
> conditionals or not.

OK, this is not a big deal (comparing with other issues).

Thanks,
Zhao


