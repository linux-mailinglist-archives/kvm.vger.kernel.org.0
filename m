Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9A91773A9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 11:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgCCKO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 05:14:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728488AbgCCKO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 05:14:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583230466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zvzf1CSZ/TEF990OeJK7NBEzQ+DyFrhGwywL/pR36+4=;
        b=FZkiPaPDDmXhm9Q3x7dsRlOPk9kPgbaf6CotVurEa4/9iuxY7rsusuEAqoG5oV74V20DMH
        o7lrfxx4PoPY4Wyjg+qjB0NXJeUmv+h5OdrBVF4mAavJU8r9zVg717Q8RcC5FaHgvlsE6Z
        aZq0eosjTX6wjR52nlOE1dBhH0IhY+g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-rqNTGmMROB2Os0HXkj6p-A-1; Tue, 03 Mar 2020 05:14:25 -0500
X-MC-Unique: rqNTGmMROB2Os0HXkj6p-A-1
Received: by mail-wr1-f70.google.com with SMTP id b12so954632wro.4
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 02:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zvzf1CSZ/TEF990OeJK7NBEzQ+DyFrhGwywL/pR36+4=;
        b=hIM/0kutELu2fpNwaS35oy3gdNdwvH6fLaXmEe1j1hlICKLH8kTVln05zXEjpyrKjQ
         MwdWX4WlukCgc1dR3K288srtkaemAYSJ73++n3+dRU+Z1v0M7HSC4yKlp8rRfyym9BcF
         L54cEIq7FoZoKLSSYIVgsgsRZiMouTncIXvRSMh3hl6sqJxy5obUXsqa6H4obRW3gn0X
         ERHl19llcjZfZVf150DsqRV4craUviDZ+24pb9GRKoIylFzfBts0CMpWQ7CDJKQHSc6B
         x3U8uDWwzS3z43AaAA2uQm53BRbWVk/WmzUOPnavfsAatmgtHnj6JTkW+HNElVVR70qj
         yPHA==
X-Gm-Message-State: ANhLgQ3Ilw2AQmn/fcKte4nGFHGVR/Luy+zymqFbU5Ee2KKy3YESsedI
        A4sKxvzTgnUBWsDAAKkvrP3erI+TxpKiPwDIwHL7MtA7j3De4ULnTZxjZ69Y3VBT0gyqkLweLEr
        JQVlSkFm0FtMw
X-Received: by 2002:adf:ec50:: with SMTP id w16mr4917955wrn.9.1583230464306;
        Tue, 03 Mar 2020 02:14:24 -0800 (PST)
X-Google-Smtp-Source: ADFU+vseXwzRJRWHYUIecMU54GEpHA+26DLVXnuPkKPp0bTiVWztmQVuJDvBkDCn7OgKWFO8iwxdMQ==
X-Received: by 2002:adf:ec50:: with SMTP id w16mr4917933wrn.9.1583230464031;
        Tue, 03 Mar 2020 02:14:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id 19sm3171981wma.3.2020.03.03.02.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 02:14:23 -0800 (PST)
Subject: Re: [PATCH 3/6] KVM: x86: Add dedicated emulator helper for grabbing
 CPUID.maxphyaddr
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-4-sean.j.christopherson@intel.com>
 <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
 <617748ab-0edd-2ccc-e86b-b86b0adf9d3b@siemens.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ddde497-9c71-d64c-df20-3b4439664336@redhat.com>
Date:   Tue, 3 Mar 2020 11:14:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <617748ab-0edd-2ccc-e86b-b86b0adf9d3b@siemens.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 10:48, Jan Kiszka wrote:
>>
>> I don't think this is a particularly useful change.  Yes, it's not
>> intuitive but is it more than a matter of documentation (and possibly
>> moving the check_cr_write snippet into a separate function)?
> 
> Besides the non obvious return value of the current function, this
> approach also avoids leaving cpuid traces for querying maxphyaddr, which
> is also not very intuitive IMHO.

There are already other cases where we leave CPUID traces.  We can just
stop tracing if check_limit (which should be renamed to from_guest) is
true; there are other internal cases which call ctxt->ops->get_cpuid,
such as vendor_intel, and those should also use check_limit==true and
check the return value of ctxt->ops->get_cpuid.

Paolo

