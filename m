Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E155DDC9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 07:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfGCFjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 01:39:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55643 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfGCFjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 01:39:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so777657wmj.5
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 22:39:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KRP+TuQazGvzJ3KRRiCbQ4I1NQbgB/6/xW/Koru4WNk=;
        b=IP0NG8fgm2cOH0PDD3Y6/fEn3dD7s+zFwCBjaaKUidaqxUILhB+lgKb6JnhTpxsjNy
         LeacojondLvbWyqtxFpZ6DFp+EoJ1VqPTAsQV8DgWnmPaCuD8+xwFkJCw85OGxIGJH5D
         wJJL/CbDrLfuaj9cqVqVHfpKRVZkgA3WGe9NIKL8LWB4orY7c1C7ol1Fnt26IdBhOKTm
         KsSrbaoRx4R7GSL78vTsmrVkLjLvhdFXiXwODBhoC77X39/4PZhaZh3MlE3X+v2i5/sn
         dKssSOLYuFDORg8DUqVIXZxFtlY+nJPMp2jv2SLwMZK82lEQFks8w7lbFbkkmGzEF/65
         j15g==
X-Gm-Message-State: APjAAAVZCKwbOm9BfQSkfrIj7JYd5lf/I3Z0SC9Yxe+th6ctVHecEmwD
        QHLmew9xEJTF2OqaKDoJoMA00TBDDAk=
X-Google-Smtp-Source: APXvYqynFZ/jO1NOzVurQZU+bAeJZ2UatlO/FmrzgFKGRpzjbMsuZAg/4YaHWSU4ZBpcTGvUvFGwNw==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr6090881wml.126.1562132377443;
        Tue, 02 Jul 2019 22:39:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id z9sm1087671wrs.14.2019.07.02.22.39.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 22:39:36 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
 <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
 <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
 <5a31871b-4010-dd01-9be6-944916753195@redhat.com>
 <954DC323-15B7-4B35-9249-AB03C9D01BB5@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6bb2a5da-9528-cea9-300a-05d328077201@redhat.com>
Date:   Wed, 3 Jul 2019 07:39:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <954DC323-15B7-4B35-9249-AB03C9D01BB5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/19 01:39, Nadav Amit wrote:
>> On Jul 2, 2019, at 11:28 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 02/07/19 19:45, Nadav Amit wrote:
>>>>> I know you are not “serious”, but I’ll use this opportunity for a small
>>>>> clarification. You do need to provide the real number of CPUs as otherwise
>>>>> things will fail. I do not use cpuid, as my machine, for example has two
>>>>> sockets. Decoding the ACPI tables is the right way, but I was too lazy to
>>>>> implement it.
>>>> What about the mptables, too?
>>> If you mean to reuse mptable.c from [1] or [2] - I can give it a shot. I am
>>> not about to write my own parser.
>>
>> Sure.
> 
> So mptable logic works on a couple of my machines, but not all.

Can you send the patch anyway?  I can use it as a start for writing a
MADT parser.

Paolo
