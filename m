Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705226B0E7
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 23:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfGPVPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 17:15:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44061 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfGPVPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 17:15:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so22417544wrf.11
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2019 14:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSc1kKHxIyyw1Y1fyS3ap04fYc8idKNJwTBNE9B+FlY=;
        b=mxwvbyiaHfcia+lQEPbIYyyAGhu86xBEQEycH6hUii8Ib8dUHLRaSQ8KqDWI5LrCui
         NqMDLQWuXtqnaoaUPdEUM/An4LBC9flCzM7rCl3KVh85CWbEVX4QMTbgzYqVnjdIY3kB
         KfimfamjbtqMgrTF/vjzcsgWZv9oN0Uo00Q1XtXvGFwB+JVzfl3TgjwuydmknNfa8g5K
         5nDEvx070molAtVAnzegYW6WCG6xYnhO8Fana8dHi7nApys98axbKSfF/ueicsyh1IBy
         i6lSRWi2pgDucIdDepG7pxN3WE4CVMzAfhcr1CYtzH8iPOZPME7XaGFZlFnE4evF4045
         1LIQ==
X-Gm-Message-State: APjAAAUbqC7IEM41bXQj56ze1Rp3Kqxv+AqoTNqVaxvNesGldDPoKp1e
        XrQzqrkzbrKWM4dUJAMwrp5OYg==
X-Google-Smtp-Source: APXvYqwqG3BlbHDEL6O6w5WIyLaoZYSCCQZs2Pf2WjPCkvjyGHMQ4mhkOnOMsMBrZMElSgt4gj9rEg==
X-Received: by 2002:adf:e708:: with SMTP id c8mr27001224wrm.25.1563311728273;
        Tue, 16 Jul 2019 14:15:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b159:8d52:3041:ae0d? ([2001:b07:6468:f312:b159:8d52:3041:ae0d])
        by smtp.gmail.com with ESMTPSA id g19sm38361063wrb.52.2019.07.16.14.15.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 14:15:27 -0700 (PDT)
Subject: Re: [Qemu-devel] [patch QEMU] kvm: i386: halt poll control MSR
 support
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Mark Kanda <mark.kanda@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190603230408.GA7938@amt.cnet>
 <1afdac17-3f86-5e5b-aebc-5311576ddefb@redhat.com>
 <0c40f676-a2f4-bb45-658e-9758fd02ce36@oracle.com>
 <86e64a5c-bb2b-00c8-56c3-722c9b8f9db6@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <48263030-768a-e8ee-302d-6d69c40b219c@redhat.com>
Date:   Tue, 16 Jul 2019 23:15:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <86e64a5c-bb2b-00c8-56c3-722c9b8f9db6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/19 23:09, Paolo Bonzini wrote:
>> As such, I think we should only enable halt polling if it is supported
>> on the host - see the attached patch.
>>
>> ...thoughts?
> No, it should not be enabled by default at all, at least not until we
> can require kernel 5.2.  My mistake, sorry.  Can you post a patch?

Doh, nevermind.  This is not included in 4.1 so there's time to fix it.
 Pfew. :)

Paolo
