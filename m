Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45067109A91
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 09:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfKZIwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 03:52:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbfKZIwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 03:52:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574758354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hW232/zztYjUv/FwF8nCT75nr0Do2+hCoMOhPXqwqiQ=;
        b=IgC/rjK559jOUoraiR5ZQ+UmhoWW+R8aES41mCXhXoQgQLaFxPJkEo+GmkTrYhcooM1jGC
        Nsq5h6VaWl37KaZuE7FtxhKirlOgfYTb40fxcBG4puQC+2pvWK/hxLIERzk5fGGiuDFGP9
        Or+0ukZi0ywErzs92g/gdegoeUCXLwA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-IOkfnLLNPHaBX8sj2sf2hA-1; Tue, 26 Nov 2019 03:52:33 -0500
Received: by mail-wm1-f70.google.com with SMTP id f16so832901wmb.2
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2019 00:52:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hW232/zztYjUv/FwF8nCT75nr0Do2+hCoMOhPXqwqiQ=;
        b=AmSQOeQFWx1veXbY3CKCQEHdjDbBlycP2dr0SAQ/54yI/rhMO9y69qUSfPuyQLDE/a
         SxjMHfvFhAbRyPSZkmj/qaybYM32syemeyj7Qr0gAqYZyKO9jJPsdAFJg7y8xWcdNPyu
         O5g6waE61e1KDCgvbxpl0QpxHDCcuPuhaPrjz2HNmgpvTOcQ/fwllXSXtbyZ13vJ9UY8
         x9NsUrowAfDCxj8lBOsxtE3Us69jiepGQVs53LTQGCKovlyAIEfeOz6GtIRNwd9J/fa8
         Nq8gMt6455J5tw6Aeqf9TflouUEWdEjSsKQfAk9DV0hn+sepQ/9lwSwR6V56z5c3rwoH
         9u5g==
X-Gm-Message-State: APjAAAXlnt68iMtAdHXpBEK6B/9FFt/FBVf8pfsA6lfWctAbEv9HKAiB
        GEtf7Z+rpuVHiBc78OfevxcW4EOBLk06BRcJuOTnUOKGzpKuz0uDuKsJBJ5qC4rJJpqApA6bnOp
        FISviermJqtsU
X-Received: by 2002:a5d:55c7:: with SMTP id i7mr36954138wrw.64.1574758351972;
        Tue, 26 Nov 2019 00:52:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxet69H/UScrBkBfZTQ2rYKh4eSWgXI0EUbUbav8IlPqiICCDTPCTnTisS3SA+p70g3HMHjCg==
X-Received: by 2002:a5d:55c7:: with SMTP id i7mr36954113wrw.64.1574758351673;
        Tue, 26 Nov 2019 00:52:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5454:a592:5a0a:75c? ([2001:b07:6468:f312:5454:a592:5a0a:75c])
        by smtp.gmail.com with ESMTPSA id t16sm2331097wmt.38.2019.11.26.00.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 00:52:31 -0800 (PST)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.5-2 tag
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Greg Kurz <groug@kaod.org>,
        Bharata B Rao <bharata@linux.ibm.com>
References: <20191125005826.GA25463@oak.ozlabs.ibm.com>
 <eff48bca-3ef0-8ae4-79d4-5e8087bded1a@redhat.com>
 <20191125234451.GA11896@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <64e3888b-495b-9f28-17b1-691cee01968f@redhat.com>
Date:   Tue, 26 Nov 2019 09:52:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191125234451.GA11896@blackberry>
Content-Language: en-US
X-MC-Unique: IOkfnLLNPHaBX8sj2sf2hA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/19 00:44, Paul Mackerras wrote:
>> Yes, of course (I have even accepted submaintainer pull request for new
>> features during the first week of the merge window, so not a problem at
>> all).
> In that case, I have a patchset from Bharata Rao which is just now
> ready to go in.  It has been around for a while; Bharata posted v11
> yesterday, and we would really like it to go in v5.5, but I thought we
> were too late.  If you're OK with taking it at this stage then I'll
> send you another pull request.

Yes, it's fine.

Paolo

