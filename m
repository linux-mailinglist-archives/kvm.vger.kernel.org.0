Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1C048D74B
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiAMMO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:14:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232841AbiAMMO1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:14:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642076066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0lIRoOhUZRcmverl2fS/N58QWJmAbrDo4GjOCnd6uY=;
        b=FnLpWe6YqOj0xlt1BTO7bzrlAKJySL7kJt7Cji8CaTp8exbknJYriigq+88/ArNLFsc2jm
        b4iNRJxfCDgtAV9B/biddxi3koT3goP80HiFQo1HCcpl//9RyFbVehMlKXwUGdX2ralXki
        oMoxGTI91WShClfreSZo52eNcJHLRvU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-3e4eYGVPMTmRnsqsXPCiUA-1; Thu, 13 Jan 2022 07:14:24 -0500
X-MC-Unique: 3e4eYGVPMTmRnsqsXPCiUA-1
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso5130356edt.20
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 04:14:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+0lIRoOhUZRcmverl2fS/N58QWJmAbrDo4GjOCnd6uY=;
        b=Kf0wFPWvux6w1E3t1UswlkcFWGqB/0WogDS/+OeS8a6h17U4ELcJZighLJdnDgVrir
         F6/5ddkBv0C/6xSf3DNzc9DRwSvENXvedkdABpqpcacPsa8G2mMmw0IxfSKX3AJVeE7X
         D5/g+Bj/HEhQ3+HfdCeSM6LqdqkCDdtVQf8WMlecmILRky0BE89tToc8rmFy1hCr375Q
         BSdkb2K0eXkJmzUXHdm85rxunBdM3Ls34ho0ingDQP/sNbOB9hcWXdAEfzwFqr+lGpDH
         McGBFCjQsmL+Be3Q9paQ3yO4VITNRS/CxxxWoQWGvQgQvhOioAMaCVOJbah46xKy/jtR
         rolg==
X-Gm-Message-State: AOAM530JzJ2SFVb8FZIa5gOEeY2n7SPO9xgzXyJdyBB0eXbGy+dgCkl4
        Wr1fu/jRUfP+IFxF1y+RMJh2bZFu4PQp5Py2gp1y+pFESD26/edX86xjMOiJHcM2mk3LYfeKRtB
        +yW3tDIrqj8Yi
X-Received: by 2002:a17:906:dc94:: with SMTP id cs20mr3224679ejc.316.1642076063779;
        Thu, 13 Jan 2022 04:14:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPQMF6TGaiElXpWlkkYzbwGgnKNg/CxUKtTPr6TZd994YwTxRDTgzO+5g21JW/xapJL8Xr3w==
X-Received: by 2002:a17:906:dc94:: with SMTP id cs20mr3224656ejc.316.1642076063508;
        Thu, 13 Jan 2022 04:14:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c9sm839546ejf.10.2022.01.13.04.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 04:14:22 -0800 (PST)
Message-ID: <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
Date:   Thu, 13 Jan 2022 13:14:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        dwmw2@infradead.org
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
 <20220113120609.736701-1-borntraeger@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220113120609.736701-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/22 13:06, Christian Borntraeger wrote:
> From: Christian Borntraeger<borntraeger@de.ibm.com>
> 
> Quick heads-up.
> The new warnon triggers on s390. Here we write to the guest from an
> irqfd worker. Since we do not use dirty_ring yet this might be an over-indication.
> Still have to look into that.

Yes, it's okay to add an #ifdef around the warning.

Paolo

