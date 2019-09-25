Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87299BDD2D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 13:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404833AbfIYLdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 07:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfIYLdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 07:33:54 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B4B6335E8
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 11:33:53 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id l3so1968687wmf.8
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 04:33:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bx730Wer+pwc4VBmfSAfJ04BjpCVUv0kzXLIsC10EIQ=;
        b=gbhqhZ5nSaUc2v813aoEp+w4L0xUwz1VPxt1dzRkX/05KIO45Bsa1dsQAURRLAqEnx
         A+D+prQtRfKBqcONoXPPCb5sClk62VAVKKGhj+0Qe3OMOtkP5STo4Gpi7gggEn2Fu8Mm
         2DEBPtLbiesC3ad9FM9EsThvT++E18hVlebF2XeqC3MegkSr6Ct5WfHh4WsoHq17NC3K
         LS850sNjwV67jUD64GCz7rfYyGVxpVIHgIePRXc3ra3H0pbIB0sPi0G6F3r6P1/Q+XkC
         11oign9vf3WiHQHyYAMXS+cVh2ua4KE7accK0h/WBsMnkXUc23emMemohuHHFieCqIdP
         GRuQ==
X-Gm-Message-State: APjAAAUPILdYKwBu+FJNyqa1sHx/2EzpgqSerWCOj6Ypy9uB3zRM9eX5
        4dq8xbJKboJ1rBeAtDcXZ1i1eF8CL3ApwdGhPgRxJMfGJZV5LHRkH0gvsJb/FJEBlqSr3O/Ex7K
        oiTLBlvBI2oy6
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr7199620wmi.151.1569411232341;
        Wed, 25 Sep 2019 04:33:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVVzdy3sluWBfXThx9vefVXa6Catg/jAgWcYuW4h3xaWL6k4hs4K+rCEuz/1gUkZjmkG355A==
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr7199588wmi.151.1569411232117;
        Wed, 25 Sep 2019 04:33:52 -0700 (PDT)
Received: from [10.201.33.84] ([195.166.127.210])
        by smtp.gmail.com with ESMTPSA id x6sm4329672wmf.35.2019.09.25.04.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 04:33:51 -0700 (PDT)
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
To:     Sergio Lopez <slp@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20190924124433.96810-1-slp@redhat.com>
 <CAFEAcA_2-achqUpTk1fDGWXcWPvTTLPvEtL+owNSWuZ5L3p=XA@mail.gmail.com>
 <87pnjosz3d.fsf@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <2d5d7297-0a02-276b-5482-948321f5a8bc@redhat.com>
Date:   Wed, 25 Sep 2019 13:33:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87pnjosz3d.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/25/19 7:51 AM, Sergio Lopez wrote:
> Peter Maydell <peter.maydell@linaro.org> writes:
> 
>> On Tue, 24 Sep 2019 at 14:25, Sergio Lopez <slp@redhat.com> wrote:
>>>
>>> Microvm is a machine type inspired by both NEMU and Firecracker, and
>>> constructed after the machine model implemented by the latter.
>>>
>>> It's main purpose is providing users a minimalist machine type free
>>> from the burden of legacy compatibility, serving as a stepping stone
>>> for future projects aiming at improving boot times, reducing the
>>> attack surface and slimming down QEMU's footprint.
>>
>>
>>>  docs/microvm.txt                 |  78 +++
>>
>> I'm not sure how close to acceptance this patchset is at the
>> moment, so not necessarily something you need to do now,
>> but could new documentation in docs/ be in rst format, not
>> plain text, please? (Ideally also they should be in the right
>> manual subdirectory, but documentation of system emulation
>> machines at the moment is still in texinfo format, so we
>> don't have a subdir for it yet.)
> 
> Sure. What I didn't get is, should I put it in "docs/microvm.rst" or in
> some other subdirectory?

Should we introduce docs/machines/?
