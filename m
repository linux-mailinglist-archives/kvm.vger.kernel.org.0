Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980D02741F3
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 14:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIVMSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 08:18:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726608AbgIVMSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 08:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600777123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNZeY9r9xWdVVmR/OV9x+niYNFf+cGcA16jaTwwfZ90=;
        b=EAbtUIJFJqUOgMAbG8oD40KmiF7gDN3FoUYcwakD+cOjV4hxCi4OiHyQILWEoDEVB5IGgd
        cYvPn+oQururJlghfCmsBG1ckenymNSNZ4xfuclaWdk8feRGvd00yAtDDL/y25dOz9R68u
        tIckhMCmfmnAD2jnteDO41eJJOwysQ8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-C22V8Bz-MZmWwa2Rquy0rg-1; Tue, 22 Sep 2020 08:18:41 -0400
X-MC-Unique: C22V8Bz-MZmWwa2Rquy0rg-1
Received: by mail-wr1-f72.google.com with SMTP id b2so1168126wrs.7
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 05:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNZeY9r9xWdVVmR/OV9x+niYNFf+cGcA16jaTwwfZ90=;
        b=J50opHoCy4PljLp5FX79j3xx5qxzpiq9xquwzrfRa3mMYHivgl2esIxfB8VpyBU5X+
         WavgBtGbc+UNmo2gvMIqlDs+67++71NtSwpYszSD1hUtK2BAnjFQSD6pj7x3mIC7Wl2e
         DomOFdmj12eSELqS30vVC/sxKo9ZT4zQaE9U/u1ZgVsCUhL5MaJhL7bf2h+sS+wksFtg
         pTnOpkyxJ+KgRu79vzQjih4LideS0tzx5aG0SfJBrbcHxATJ+jtDsrF2uEQMFEZ313MJ
         Vo5MDUrG7Jrt3WQIGVhtNRk2JxLo84yNfsFT00xZxwmNj9yQ7bwHQEZv1/K3ySjmPzaq
         dd5A==
X-Gm-Message-State: AOAM53245YjYHSyYT6fDQ36CnwwcDn+gFk10LcPkqfVEYbSyjXEHGOqo
        PzR1g0S7hud6MVncyX01xlFRq19v70xkj+hd7nAIhBC06zS2RKWG944NUwVLr6kP8pJmBxAwApW
        jA9bi7fM86h4B
X-Received: by 2002:a05:600c:2189:: with SMTP id e9mr754164wme.8.1600777120300;
        Tue, 22 Sep 2020 05:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyltv95D02XwMDIvvSOgO71sFd0oy5jdM3qkUXkXfyr1VqYo6t24oZfKylnZb/F1LLhv96mPA==
X-Received: by 2002:a05:600c:2189:: with SMTP id e9mr754148wme.8.1600777120115;
        Tue, 22 Sep 2020 05:18:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id u63sm4618338wmb.13.2020.09.22.05.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 05:18:39 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.10-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20200922041930.GA531519@thinks.paulus.ozlabs.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2540d3b-844f-f204-7783-079ad9103ada@redhat.com>
Date:   Tue, 22 Sep 2020 14:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922041930.GA531519@thinks.paulus.ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 06:19, Paul Mackerras wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.10-1

Pulled, thanks.

Paolo

