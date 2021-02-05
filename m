Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5B831131A
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhBEVIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 16:08:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:28055 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233604AbhBETMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:09 -0500
IronPort-SDR: gsWqV96ITRrZ22HcE7cu5owf2BZw2GEwf52zOTQHpPDMO0KuwHy/RD8zI7uBHwQmfnIjby3uZK
 yTLJuQ+Rz06w==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="180711254"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="180711254"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:52:50 -0800
IronPort-SDR: lgHN/v12VV3ovvexLRsvsJwgV5WcoPPRk/SWeAg19Gounw59TTqQPAi/r+KPaoedYJwVtngGUe
 n0vPu0AO2Giw==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="394010888"
Received: from tassilo.jf.intel.com ([10.54.74.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:52:49 -0800
Date:   Fri, 5 Feb 2021 12:52:47 -0800
From:   Andi Kleen <ak@linux.intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RESEND] perf/x86/kvm: Add Cascade Lake Xeon steppings to
 isolation_ucodes[]
Message-ID: <20210205205247.GF27611@tassilo.jf.intel.com>
References: <20210205191324.2889006-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205191324.2889006-1-jmattson@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 11:13:24AM -0800, Jim Mattson wrote:
> Cascade Lake Xeon parts have the same model number as Skylake Xeon
> parts, so they are tagged with the intel_pebs_isolation
> quirk. However, as with Skylake Xeon H0 stepping parts, the PEBS
> isolation issue is fixed in all microcode versions.
> 
> Add the Cascade Lake Xeon steppings (5, 6, and 7) to the
> isolation_ucodes[] table so that these parts benefit from Andi's
> optimization in commit 9b545c04abd4f ("perf/x86/kvm: Avoid unnecessary
> work in guest filtering").

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
