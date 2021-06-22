Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89B3B0A47
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVQ17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhFVQ17 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624379142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjqaP9Z8UpgwrTU8DHBWtrD6r/Zid6ORfkGZGN1NUwQ=;
        b=BpO/YQyiYsU0oqgJmIErZOLPlWELI8JgQEK7XTChoRyPT7+lmj9U+9ipFhJFp31/6P48fQ
        DKCO6bGh1wDDmUPrgsuqzeKlcbI2SpWZtUvJzuz9HZMB+YgUvDR6Km2aNiIEhuKvnEf6Md
        RTairNprCRXRmjbzazvORc1tUtXNtz8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-Oagpnj8DPRWEJy9gRbv2MQ-1; Tue, 22 Jun 2021 12:25:41 -0400
X-MC-Unique: Oagpnj8DPRWEJy9gRbv2MQ-1
Received: by mail-wm1-f69.google.com with SMTP id g14-20020a05600c4eceb02901b609849650so902073wmq.6
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 09:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vjqaP9Z8UpgwrTU8DHBWtrD6r/Zid6ORfkGZGN1NUwQ=;
        b=GFX6eBY7TLBTNrjhv9UASLMHUmBPJtfIEubdUOVZJ4cI9DK+sd5KIRwdo8PuuOI6Mp
         7u1t4gswH621Tf+96C7FF4QrDTmaNDpoFje3ycsc0j+AeT6vXFMt3/aNtjs/l6oo1NlY
         v5jZV0tVVJrGrm1wgPc9ZFzaCiFZa93/nK7z+wgkd7c/sOgbN3dKrMuBdXg0zx1WT1EE
         mIe9uaJmAPKKbB6geT0UYV22oOpWRZieFaG6LUxrkonZQ1Ku1T7FywVgwHT0aEEAJMVH
         RMzwaXFGGktAwmaMtFQNl7i5f8RyfMnlB9mIMRZBLobsWwn0Zz71hHPDi71aeN9+DOBM
         jioQ==
X-Gm-Message-State: AOAM533/z+mSf8SPHkE+7SCVhcAbJa8MAYA/QMmDxeTEkp6dmdTq+Kah
        68LsQeBViLCqPhMmajQ9GAPJ/zyFL//+mMXTdB6d7XsXKkkzOu1ZKRvfyxf/sLlS9hvVZZVoHFS
        Qs2zFwkB31KzM
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr4151602wrx.206.1624379139784;
        Tue, 22 Jun 2021 09:25:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuuYvVtHoTe9VGU82USBbvdDmOc1QFRrl8B1NHWep4YfgrR6ZFUxpJLAwMcq3Z3RkUw6ELIA==
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr4151586wrx.206.1624379139642;
        Tue, 22 Jun 2021 09:25:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n18sm3059855wmq.41.2021.06.22.09.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 09:25:39 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/4] Test compiling with Clang in the
 Travis-CI
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20210622135517.234801-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4130711c-2c22-c417-5e88-a68e610ae891@redhat.com>
Date:   Tue, 22 Jun 2021 18:25:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622135517.234801-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 15:55, Thomas Huth wrote:
> Travis-CI recently changed their policy so that builds on the non-x86
> build machines are possible without consuming any credits again.
> While we're already testing the non-x86 builds in the gitlab-CI with
> the GCC cross-compilers, we could still benefit from the non-x86
> builders in the Travis-CI by compiling the code with Clang there, too
> (since there are AFAIK no Clang cross-compilers available in the usual
> distros on x86).

Looks good apart from Claudio's remark.  Thanks very much!

Paolo

