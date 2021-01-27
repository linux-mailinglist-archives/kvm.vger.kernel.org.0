Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7943030606F
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 17:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343618AbhA0QA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 11:00:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236704AbhA0P7s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 10:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611763101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xALEDRJaRGE82grm8YWm4+/Jy25X4Iq0vYk0w7ML5yI=;
        b=HGySXygboAigpEFKNki4IRDFfd8p2XDtBwEuKcYhl+0spTcW26OGA603ecynZdF5g8M9W+
        8G1R/rN23LfEmGcfG+okNryJ6PajQyEabekoeRIOZDVGds+SkfsD9mx4tDB8VK8nG/ZOrE
        2u8OzSR2wQZ50SbKFopbQ2z2jozwtLs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-KXw8XWV5P9WcTcsZ2_iFMg-1; Wed, 27 Jan 2021 10:58:20 -0500
X-MC-Unique: KXw8XWV5P9WcTcsZ2_iFMg-1
Received: by mail-ed1-f70.google.com with SMTP id q12so1591215edr.2
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 07:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xALEDRJaRGE82grm8YWm4+/Jy25X4Iq0vYk0w7ML5yI=;
        b=iXTIf1/awdkx6XXnsMT4FqSitZRHrnKwLzqUI/rMl05++rhgUY98fug0T3i+Ti2J+g
         /kja3+EdyGmQU0jnRVdxlC05wb9UglLkIef4pea8I1zRRhKIJSpkOQ0W4RfZlhhG/BN1
         Inm/hbi5YGbs+rO9LDJIy2h4DUg+b/Q21dQ7FEDfwx4vLsUkUww0KAD/YIi9lEe3QZyU
         KAPxB5YKw4FvXMQDr4kbWjMdmnhcq73JcJG98Y2Vzxp86tu0mvLFZR34IqO4rKKnCAaX
         z4wY96QzXPk/tnZ51fcsMgF/c6duaqbwTNwyFF1aMeHVHhJD7J4a3t/bqoKjtP0PNbcZ
         b2Sw==
X-Gm-Message-State: AOAM531NaYTsBz+RpP6Hbwf6niprw9lYVBFAJpVZ/YOcOSug8nki8uL6
        Unwz87JkJzGG7C4UK2eih4TL5H1lYhHfI55DiIdpWRH1yHWcShBzGuqdGOyzX2wcyX/KWr7l7sQ
        yOa4wTySTrde+mAT73fIHhGKQ4wTCJQJTiVzFqAxoD0iIfrn0i6N6j8vVlY/38qKj
X-Received: by 2002:a17:907:175c:: with SMTP id lf28mr7420880ejc.110.1611763098735;
        Wed, 27 Jan 2021 07:58:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkY6kKAgtp4zogVIfCCQiyc9fSiX1/eaykBytSZmoPUkeINUoEGCtz/1A9eb8b1imJD4Z3pw==
X-Received: by 2002:a17:907:175c:: with SMTP id lf28mr7420861ejc.110.1611763098473;
        Wed, 27 Jan 2021 07:58:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n20sm1518115edr.89.2021.01.27.07.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 07:58:17 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] x86: use -cpu max instead of -cpu host
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20210127095234.476291-1-pbonzini@redhat.com>
 <06b67a9d-ed15-59e5-3849-c3b9f6665138@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3e9dcb51-b3a5-cf8e-019c-51f41b4571fb@redhat.com>
Date:   Wed, 27 Jan 2021 16:58:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <06b67a9d-ed15-59e5-3849-c3b9f6665138@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 16:54, Thomas Huth wrote:
> On 27/01/2021 10.52, Paolo Bonzini wrote:
>> This allows the tests to run under TCG as well.  "-cpu max" is not 
>> available on
>> CentOS 7, however that doesn't change much for our CI since we weren't 
>> testing
>> the CentOS 7 + KVM combination anyway.
> 
> "-cpu max" has been added with QEMU v2.10 ... Wasn't there the 
> possibility to install a qemu-kvm-ev package instead of the normal 
> qemu-kvm package on CentOS 7 ? qemu-kvm-ev should likely be new enough 
> already, I guess?

Yes, that would work too.  I'm not sure if that version would also be 
able to run emulated SMAP or PKRU tests.

However, runnning on old TCG is of limited use because it's bound to 
encounter emulation bugs.  It is of course useful to have a smoke test 
to ensure that we don't encounter compilation issues, of course!

Paolo

