Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A62120A54E
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 20:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406098AbgFYS44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 14:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405853AbgFYS44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 14:56:56 -0400
X-Greylist: delayed 16199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Jun 2020 11:56:56 PDT
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48046C08C5C1
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 11:56:56 -0700 (PDT)
Received: from kevinolos (2600-6c67-5080-46fc-c41a-e0b6-d707-8cad.res6.spectrum.com [IPv6:2600:6c67:5080:46fc:c41a:e0b6:d707:8cad])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 5E7F01A0EE11;
        Thu, 25 Jun 2020 18:56:53 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 8BFD71300396; Thu, 25 Jun 2020 12:56:51 -0600 (MDT)
Date:   Thu, 25 Jun 2020 12:56:51 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
Message-ID: <20200625185651.GA177472@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
References: <20171018174946.GU5109@tassilo.jf.intel.com>
 <3d37ef15-932a-1492-3068-9ef0b8cd5794@redhat.com>
 <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
 <20200625142651.GA154525@kevinolos>
 <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fbd0871-7a72-3e12-43af-d3c11c784d83@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the info Paolo and Andi!

On Thu, 2020-06-25 at 20:41 +0200, Paolo Bonzini wrote:
> On 25/06/20 16:26, Kevin Locke wrote:
>> 1. Do I understand correctly that the CPU usage is due to counting
>>    RTC periodic timer ticks for replay when the guest is resumed?
> 
> Yes.
> 
>> 2. If so, would it be possible to calculate the number of ticks
>>    required from the time delta at resume, rather than polling each
>>    tick while paused?
> 
> Note that high CPU usage while the guest is paused is a bug.  Only high
> CPU usage as soon as the guest resumes is the unavoidable part.
 
[...]
 
>> 5. I have not observed high CPU usage for paused VMs in VirtualBox.
>>    Would it be worth investigating how they handle this?
>> 
>> From the discussion in https://bugs.launchpad.net/bugs/1851062 it
>> appears that the issue does not occur for all Windows 10 VMs.  Does
>> that fit the theory it is caused by RTC periodic timer ticks?
> 
> Windows 10 can use the Hyper-V synthetic timer instead of the RTC, which
> shouldn't have the problem.

That's great news!  Since I'm able to reproduce the issue on a
recently installed Windows 10 2004 VM on Linux 5.7 with QEMU 5.0, is
there anything I can do to help isolate the bug, or is it a known
issue?

Thanks again,
Kevin
