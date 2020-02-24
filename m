Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8ACC16AD75
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgBXRah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:30:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:25901 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgBXRah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:30:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 09:30:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,480,1574150400"; 
   d="scan'208";a="255649407"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 24 Feb 2020 09:30:33 -0800
Date:   Mon, 24 Feb 2020 09:30:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, namit@vmware.com,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
Message-ID: <20200224173033.GE29865@linux.intel.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <b0b69234-b971-6162-9a7c-afb42fa2b581@redhat.com>
 <CA+G9fYu3RgTJ8BM3Js3_gUbhxFJrY6QTJR-ApNQtwFh+Ci0q8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu3RgTJ8BM3Js3_gUbhxFJrY6QTJR-ApNQtwFh+Ci0q8Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 10:36:54PM +0530, Naresh Kamboju wrote:
> Hi Paolo,
> 
> On Mon, 24 Feb 2020 at 18:36, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 24/02/20 13:53, Naresh Kamboju wrote:
> > > FAIL  vmx (408624 tests, 3 unexpected failures, 2 expected
> > > failures, 5 skipped)
> >
> > This could be fixed in a more recent kernel.
> 
> I will keep running these tests on most recent kernels.
> 
> My two cents,
> OTOH, It would be great if we have monthly tag release for kvm-unit-tests.
> 
> LKFT plan to keep track of metadata / release tag version of each test suites
> and kernel branches and versions details.
> 
> Currently LKFT sending out kselftests results test summary on
> each linux-next release tag for x86_64, i386, arm and arm64 devices.
> 
> The next plan is to enable kvm-unit-tests results reporting from LKFT.

Rather than monthly tags, what about tagging a release for each major
kernel version?  E.g. for v5.5, v5.6, etc...  That way the compatibility
is embedded in the tag itself, i.e. there's no need to cross reference
release dates against kernel/KVM releases to figure out why version of
kvm-unit-tests should be run.

Paolo more or less agreed to the idea[*], it's just never been implemented.

[*] https://lkml.kernel.org/r/dc5ff4ed-c6dd-74ea-03ae-4f65c5d58073@redhat.com
