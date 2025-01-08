Return-Path: <kvm+bounces-34743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88953A0529C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 06:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82E27165A1A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522AA1A238A;
	Wed,  8 Jan 2025 05:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWUh9TXf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA370838;
	Wed,  8 Jan 2025 05:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736314152; cv=none; b=Q5CHr/hN5XlNBrKe/Ik76JVKBMZyIwPp723Z9aVY7ri7TSSYVUjyUX0nNG3JigVlEl9r+jnt8auT77J64j8BifYe5ZgVufmTitka/xwx+h7/RU4HiRCMZ9GLi0qMQTwXW1OAlnH3R6Jl/scV83/2PeUXBY/NVjfHp+O/hgYjy+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736314152; c=relaxed/simple;
	bh=4emmKJQ7Hy1yYta3PiUPxzlpraIwwfAeZXd9UNqwFFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5j97g6thROehBHZXTebncLOEQzIb3DJTAUzEXYr/uU3yrmpZ9dbcnPmmm+vmJcFbajcZkaFp3jCI9zDtG/jtfxu54jDSjbAFt/bZDAoRBmFoqRJRjt7nbEjz/I0IXZR4NwYsTVsM9SpWZhYET1inzfGf1zL0jknY118PcoKKoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jWUh9TXf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736314151; x=1767850151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4emmKJQ7Hy1yYta3PiUPxzlpraIwwfAeZXd9UNqwFFg=;
  b=jWUh9TXfoub5QV2KZiahIeRIQUfWR09CsGITq5qCS5Ta/PYXep7hNttp
   WvX6wlyfRWkq0LOdfK+owEsv09Ysa/eAtwUmJYhapAWgFBJ84bXHBysC0
   ObqeuZDpcQ/CSzG7oyRNNWdRYlRj2MgPL0K6xFdIRd82Qzj3IP/e6uQp+
   pkOSsXUXclFFgnWGEmhDAuR2auBGrD5RKwyMy3uyWOGh9YsrKOrIE+W1j
   yoWMlDT0d8SLpwwGwFyMQhGM6DQzKebaYLA4wMRqCYGZP90kjRpUOummv
   BseZPS0wl/TQDu9e3cQOQxODYhEZ3sDuEpr0BGPJqCd7829p/Q4EUUUuu
   Q==;
X-CSE-ConnectionGUID: Sfm6GoRIRXK2CvD9fpSo0Q==
X-CSE-MsgGUID: hoEjWdLwQdKH9/3UXPMShw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47881237"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="47881237"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 21:29:10 -0800
X-CSE-ConnectionGUID: cS+0cikhQ7yibe7UdBqiXQ==
X-CSE-MsgGUID: qWc4eULSQ2yqT2bvvpk0Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="133884763"
Received: from mklonows-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.131])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 21:29:04 -0800
Date: Wed, 8 Jan 2025 07:28:59 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Message-ID: <Z34NGyZL7G_j716N@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
 <Z3zZw2jYII2uhoFx@tlindgre-MOBL1>
 <7f8d0beb-cc02-467d-ae2a-10e22571e5cf@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f8d0beb-cc02-467d-ae2a-10e22571e5cf@suse.com>

On Tue, Jan 07, 2025 at 02:41:51PM +0200, Nikolay Borisov wrote:
> On 7.01.25 г. 9:37 ч., Tony Lindgren wrote:
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -139,6 +139,8 @@ __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> >   EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> >   __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
> > +EXPORT_SYMBOL_GPL(apic_hw_disabled);
> 
> Is it really required to expose this symbol? apic_hw_disabled is defined as
> static inline in the header?

For loadable modules yes, otherwise we'll get:

ERROR: modpost: "apic_hw_disabled" [arch/x86/kvm/kvm-intel.ko] undefined!

This is similar to the EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu) already
there.

Regards,

Tony

