Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF40B1CEF43
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgELIik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 04:38:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54635 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725868AbgELIik (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 04:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589272719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uhxGBcmzvEb9xpb17BW7KegR0sKrqRYZ7uSobvEaw7c=;
        b=P/kiBaRUOYnwWNaFUL4UzsjsVBTHjkTm2wCesk7uq+836LRBIQdktZd0RAhCeU9e0jp+5t
        g9xVU40C8mqFd2fXSq5OBdta40N+I2qk2mwPE5pmISHIm5ZWQrGgI/G/7/f+2F6w2I12z0
        L858qDAkNLQ/y6R/w2jN5LTeG8fvXJE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-2VDiPzD4OUu0amltQXXJMg-1; Tue, 12 May 2020 04:38:37 -0400
X-MC-Unique: 2VDiPzD4OUu0amltQXXJMg-1
Received: by mail-wr1-f69.google.com with SMTP id z10so2588951wrs.2
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 01:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uhxGBcmzvEb9xpb17BW7KegR0sKrqRYZ7uSobvEaw7c=;
        b=G/fYk0W2k+F7Z5AlQj54NTzS9W4f0vckROaCvJK4iw0kS4TmUrILE5l0R4245wz2VG
         zUjD1CruQU/oTC1KXPpB+OoF7mJb0jFy+htUZKX6bpT4QivDq7T6Jjax9NXFXACD/854
         XVd51Ptns+nhtdAwxwcLJXMFS0d1MDpRMh5V12sDJ3DPsKP4+1hBudX+japqo42wnaSl
         Zs+69+BLI7wqHGfUKDXfxx0R53E/RmdIw4BD9dirdyqA5FmIDET/if5RXcGLbIxi/wVP
         9bmFVcX6BwPwRRE2qI8vp9Q5/GXSBufexQ4461+NTVkXC1FuePxHcRofOGdnQdz92d3W
         tb8w==
X-Gm-Message-State: AGi0PuZdDnfxbKjECGnJUvkovDJHYnMp+pXdTlQzFncZ5DtJo94fDeFa
        7v/0q4n6zoU+ckysVnszQwu4jqeq6ibwKJQfbj93Hi48+5hiP/gP7L6njBO8dL1SjmSwPji8cds
        CubksdGowHqVj
X-Received: by 2002:a7b:c38b:: with SMTP id s11mr36175790wmj.55.1589272716778;
        Tue, 12 May 2020 01:38:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypLOYicSNn+oJcHuty5SptLNpNWpSrA2+y+/X4KTYk9QiYhv9zoCoFY8x4jvhiHC+MksxotoXw==
X-Received: by 2002:a7b:c38b:: with SMTP id s11mr36175779wmj.55.1589272716593;
        Tue, 12 May 2020 01:38:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4c95:a679:8cf7:9fb6? ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id v20sm24074991wrd.9.2020.05.12.01.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 01:38:36 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] x86: avoid multiply defined symbol
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20200511165959.42442-1-pbonzini@redhat.com>
 <3a74a455-6d58-900d-f38a-348539e8d389@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a25199fd-5b8d-d7bc-6e7b-884794a0d9e7@redhat.com>
Date:   Tue, 12 May 2020 10:38:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3a74a455-6d58-900d-f38a-348539e8d389@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/20 08:01, Thomas Huth wrote:
> Seems like GCC v10 defaults to -fno-common now? Maybe we should add this
> to the CFLAGS of the kvm-unit-tests, so that we get the same behavior
> with all versions of the compiler?

Yes, good idea.

Paolo

