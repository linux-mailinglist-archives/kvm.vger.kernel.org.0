Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8082875D2
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 16:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgJHOPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 10:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730356AbgJHOPY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 10:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602166522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjhr21aSsRJ5tXiLgKrndxaDa4eu0MrzGpsG+lYcc64=;
        b=PO1uOxLHY+EmO7jf53EzBQ7pCtomLb9Ad0Me/Jhgp1nnEZi9ngl5XVkTcQjHZxKkhctwQ5
        TvmARqL3y7Qg2qH8kcqVxolN7l6QdxPKFk4utrjvZbhQp9dptmKaHVJII3S6QkFnYllp6j
        xCNZTlD7FVDYUNWdCRKy3c45QnruHmI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-qiqPTBcIMha9xzROtTtUmw-1; Thu, 08 Oct 2020 10:15:19 -0400
X-MC-Unique: qiqPTBcIMha9xzROtTtUmw-1
Received: by mail-wm1-f69.google.com with SMTP id s12so4100504wmj.0
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 07:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bjhr21aSsRJ5tXiLgKrndxaDa4eu0MrzGpsG+lYcc64=;
        b=a/L4uZW0He1DEkmU6XC+uU8971WSRS6fADmWKgsYsdEL304UQ9mBrAzS8qRiU9yEoz
         Ymtot2eoAno6ZVeSfSaSPcoSsiSw57DeVvZvYVqs8PnK+/w2X0OggkMvlXqmt5FuVqVO
         3KYiPrVvjk7CxyqJvK6bNruYCmjECU9mq8Fl4i9DEPjxpXwkjwlPr5Zy6Pt3M+LicuXY
         9asRzL2V9X41KFHdHEAOJmwHXEORXszJL+O4TuqjOLz7nmsPVrzzocS6/83VxMRRUWEI
         ZVP5OnqGkdRq9+E2tkOpE/vkCSvWJNXlg1SRIrFb6D19JmT+phd2A8F4nTseWr+EDP8A
         lBBA==
X-Gm-Message-State: AOAM531UTAsTiIOhBT9KI+Nouskeja79G82bV5KbfQCVNCBjEgfgS8LX
        Ci7WhYEXjGhY3PSnAjL2cuNWJsODg1q/3CHJiw8r1hUm/djR0UCzM8HnLhCndoN8z96jMSUlU9W
        jae/i3KAo+Bhg
X-Received: by 2002:adf:fd07:: with SMTP id e7mr9188236wrr.377.1602166518683;
        Thu, 08 Oct 2020 07:15:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKXhWOWCMYprz5YdVnK8pbDploupp7kZZ7lRm7tvunRvnLArwt+lAHqrYnruBG3qs+SXnt+Q==
X-Received: by 2002:adf:fd07:: with SMTP id e7mr9188213wrr.377.1602166518440;
        Thu, 08 Oct 2020 07:15:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bb8c:429c:6de1:f4ec? ([2001:b07:6468:f312:bb8c:429c:6de1:f4ec])
        by smtp.gmail.com with ESMTPSA id f14sm7570622wme.22.2020.10.08.07.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 07:15:17 -0700 (PDT)
Subject: Re: KVM call for agenda for 2020-10-06
To:     Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, John Snow <jsnow@redhat.com>
References: <874kndm1t3.fsf@secure.mitica>
 <20201005144615.GE5029@stefanha-x1.localdomain>
 <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
 <8fce8f99-56bd-6a87-9789-325d6ffff54d@redhat.com>
 <20201007180429.GI2505881@redhat.com> <87h7r5yn6z.fsf@dusky.pond.sub.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a35bad26-7ed6-fea8-10ab-ea340f8fc6e2@redhat.com>
Date:   Thu, 8 Oct 2020 16:15:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87h7r5yn6z.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/20 13:25, Markus Armbruster wrote:
> CLI, config file and QMP are differently convenient for different use
> cases. [...]
> 
> If we could afford just one of the three, we'd probably want to pick
> QMP, because it's the most flexible (it's supports queries naturally),
> and because picking something else can't eliminate QMP.  Fortunately, we
> don't have to pick just one if we base on initial configuration on QAPI.

On the other hand, we don't have to pick just one because we already
have a CLI (though one that is full of warts) so the question is not
whether we want to have a CLI, but whether we want to have a *second* CLI.

So my point is essentially that:

* as you said, you cannot get rid of QMP

* we can make the existing CLI a QMP wrapper just like we did with HMP

* any work on QMP-based configuration would apply just as well to both
binaries, so developers could still mix CLI+QMP when (or if) desirable

* once you have a (warty but well-known) CLI and QMP, there are
diminishing returns in going all the way down to QAPI even for the two
hardest commands (device-add and object-add).  That time is better
invested in minimizing the differences between the two binaries, because
we all know that you won't pry the qemu-system-* command line from the
cold dead hands of users and developers.

(not coincidentially, this goes from least to most controversial).

Of course you may say this is "whataboutism", on the other hand time is
limited so I prefer to make the interesting tasks clear from the
beginning and allow better collaboration.

> I'd like to take a serious swing at QAPIfying them, with a loose schema.

What do you mean by "loose schema"?  Is it anything other than
"represent a QDict with a QAPI list of key-value pairs"?

Paolo

> Good enough for QAPI-based initial configuration interfaces.  Not good
> enough for introspection, but a better QOM introspection could fill that
> gap.
> 

