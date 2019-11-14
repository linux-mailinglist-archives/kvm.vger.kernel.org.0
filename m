Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71914FC140
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 09:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfKNIJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 03:09:28 -0500
Received: from thoth.sbs.de ([192.35.17.2]:37567 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfKNIJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 03:09:27 -0500
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id xAE89CZT030781
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 09:09:13 +0100
Received: from [167.87.46.11] ([167.87.46.11])
        by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id xAE89CH4016661;
        Thu, 14 Nov 2019 09:09:12 +0100
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
 <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
 <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <e86c01a8-8265-5e42-2fae-2c42c7e3d961@siemens.com>
Date:   Thu, 14 Nov 2019 09:09:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <dffb19ab-daa2-a513-531e-c43279d8a4bf@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.11.19 22:24, Dave Hansen wrote:
> On 11/13/19 12:23 AM, Paolo Bonzini wrote:
>> On 13/11/19 07:38, Jan Kiszka wrote:
>>> When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
>>> couldn't simply be handled by the host. But I suppose the symptom of
>>> that erratum is not "just" regular recoverable MCE, rather
>>> sometimes/always an unrecoverable CPU state, despite the error code, right?
>> The erratum documentation talks explicitly about hanging the system, but
>> it's not clear if it's just a result of the OS mishandling the MCE, or
>> something worse.  So I don't know. :(  Pawan, do you?
> 
> It's "something worse".
> 
> I built a kernel module reproducer for this a long time ago.  The
> symptom I observed was the whole system hanging hard, requiring me to go
> hit the power button.  The MCE software machinery was not involved at
> all from what I could tell.

Thanks for clarifying this - too bad.

> 
> About creating a unit test, I'd be personally happy to share my
> reproducer, but I built it before this issue was root-caused.  There are
> actually quite a few underlying variants and a good unit test would make
> sure to exercise all of them.  My reproducer probably only exercised a
> single case.
> 

Would be interesting to see this. Ralf and tried something quickly, but 
there seems to be a detail missing or wrong.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
