Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4BD132D2A
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 18:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgAGRgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 12:36:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24256 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728266AbgAGRgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 12:36:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578418590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0BVxVyPA1Jmng3rASaLeYwHaaw23k7+8XInxcOt1F4=;
        b=M3qIBKLW54kICtd75P5JcYynR32jViQKLzFyoEu8fK3f6r0u34/dyS9AhEqcCtTj2WNnxE
        QIumhIbXKrNtbVDLa72RP8uTMDjSmRpFCknbQiSXyDZYkK9yUQvcicrMaGktZJSuiL3C4C
        w/jtE4VL7EEgmv8VDP3OXx1X6jtCAOs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-mH3lz1xpPMqImZTP9GylYg-1; Tue, 07 Jan 2020 12:36:25 -0500
X-MC-Unique: mH3lz1xpPMqImZTP9GylYg-1
Received: by mail-wr1-f72.google.com with SMTP id r2so244427wrp.7
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 09:36:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j0BVxVyPA1Jmng3rASaLeYwHaaw23k7+8XInxcOt1F4=;
        b=pKHcnrbikBNNtrtw/FcQoIOxvd7WU8YkeYQsFY+zlc+oKzaabu1UUIaHDD9G5UnMIr
         wPsigYpccVLv9DfslsNxB8J8tjGpPrqjk2J5h+Y6jXvaoYEFGrLUfy1dM14Z1U+MZ4pp
         NgBKYfY0Wx9SqdcdBnMNXunrasrxTYVJbc+5hxDDGa6FNg2I+xubqSMYF42lVi044suK
         5mTQsJ5gq/0c+arJmjAWm7tYreTOUcmn1HA6jJpr9kJpNlqJe1JAbXgFEAI5PFc0dvfd
         AVtXI/Wtlu7VNmwWmKUrSvEt5/UgWjQThPVqIfj9QzCC7l36t1AnbsFw6uN4/soIgsaU
         SEVg==
X-Gm-Message-State: APjAAAUggaVOj4+h64+yK8sRKh4t3epyUK3EPz+NcuLPASLIebtNoNsU
        1aoLhNrPw/nnEG1vJ2BuUyJwaUyymlOKkNqIFYlHnxtr6DoHuXJUQlKZJPzw5LkAYbTuRwjyPhQ
        RvukKA1SkEXIh
X-Received: by 2002:adf:ed83:: with SMTP id c3mr182527wro.51.1578418584036;
        Tue, 07 Jan 2020 09:36:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqyqANdMtX3lHHJxn/EmrMN5p7pw/bhzBS5mpFfBrzSC2E5KRFyuNQFHXnRGq0BKMzA7OAG7GQ==
X-Received: by 2002:adf:ed83:: with SMTP id c3mr182509wro.51.1578418583791;
        Tue, 07 Jan 2020 09:36:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id a16sm671634wrt.37.2020.01.07.09.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 09:36:23 -0800 (PST)
Subject: Re: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
To:     Gregory Esnaud <Gregory.ESNAUD@exfo.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
 <a8fb7ace-f52e-3a36-1c53-1db9468404e6@redhat.com>
 <fc4a7dfc9d344facaed8d34adcff3fc4@exfo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3193f727-1031-b76b-4b3b-302316c9d058@redhat.com>
Date:   Tue, 7 Jan 2020 18:36:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <fc4a7dfc9d344facaed8d34adcff3fc4@exfo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/20 18:32, Gregory Esnaud wrote:
> Hi Paolo,
> 
> Thanks for your quick answer.
> 
> Are you using only 2 CPUs at 100%, or are you using 9 CPUs at a total of 200%? 
> 
> Inside the VM, a top command show that we are using 2 CPU @ 100%: https://framadrop.org/r/gNf3erJVf6#t2HLIpzPHGtxHzHeLrnGGjsRSZZpmv9HPVZt/LIIP8s=
> From the hypervisor (ie, *outside* the vm), a top command show that the VM consuming 9 cpu: https://framadrop.org/r/-FmrBhMGX5#q/6aZ8Fq2Mnuzz3+6F/pa83U+jzPox1hd984tw7DkuA=
> 
> So, if I'm understanding you correctly, an parameter of kernel of our VM is idel=poll that we should change?
> 

That's a possibility.  And if it's correct, your provider is certainly
correct in complaining. :)

Paolo

