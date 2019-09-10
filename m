Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DA3AEDBC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfIJOvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732971AbfIJOvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:51:44 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 334DA882F5
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:51:44 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id t185so1459198wmg.4
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=asBr1a17x6YvFMcLDTb8W5jhTolw9yYMR4FeRcRJtVY=;
        b=BG38D51nVQHw2Zt3XwEQ9Tvh2Ip77IiwPRml+SaNMYwvbzOFgPOT8TqWzbmjQxY8p/
         syhANAdM6xEA2euSb3NDZLtdptPf4SHZZplQyfm8efiobCdHcDj+uvutMKXUyDnx4qvo
         iLURCGUZFzO5Fwr24MUMewJr6WjAcbQDMPNRs0pnND4GyPuDKACAWcExOJUaHmy0Af6k
         W/WUdyYYRyD/3LF382ZKouVG0ty6yNmYhzwza4rYDtr/ItYkQVgCmRvWI54zdxjfGrMp
         HAT+RXoxW+rg6zC7MJAbX9ApcW1D4HrLf21QIK6cByHZKqzGf9UyyhZ2CAFAEhV/KLn2
         EFog==
X-Gm-Message-State: APjAAAUGMiV6MhUPughARqlk4H000E3S/X56EupZ3TJr+KxLpc8RTyVD
        n8sO7kIQucYoepiDCi5yuLJcEdyaUZck0m2KuptSyKL3VKXGwkdZKIU5RXqhutrxqNM6j+W1tfu
        kI1P+YcZ4boQY
X-Received: by 2002:a5d:6691:: with SMTP id l17mr25443268wru.262.1568127102815;
        Tue, 10 Sep 2019 07:51:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwix+KKRCN4iDMtASkBpHgJ0ywEBfzmKD95E+KF0yd7HENBWUJdTMKUkICkQs0GDSbVmoV/ww==
X-Received: by 2002:a5d:6691:: with SMTP id l17mr25443239wru.262.1568127102582;
        Tue, 10 Sep 2019 07:51:42 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q26sm3625546wmf.45.2019.09.10.07.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:51:41 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.4-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20190828232353.GA4485@blackberry>
 <20190906120415.GA1625@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <19d5c1c1-1567-148f-5fde-4bbd78e7dca9@redhat.com>
Date:   Tue, 10 Sep 2019 16:51:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906120415.GA1625@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/19 14:04, Paul Mackerras wrote:
> On Thu, Aug 29, 2019 at 09:23:53AM +1000, Paul Mackerras wrote:
>> Paolo or Radim,
>>
>> Please do a pull from my kvm-ppc-next-5.4-1 tag to get a PPC KVM
>> update for 5.4.  There is not a lot this time, mostly minor fixes and
>> some prep for future patch series, plus a series that fixes a race
>> condition in the XIVE interrupt controller code where interrupts could
>> arrive after free_irq() and cause hangs and crashes in the host.
>>
>> The XIVE fix touches both PPC KVM and generic powerpc code, so Michael
>> Ellerman put it in his topic/ppc-kvm branch and I have merged that
>> branch into my kvm-ppc-next branch.
> 
> Ping?

/me emerges from a pile of unread email

Pulled, thanks!

Paolo

