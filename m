Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9454323809
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 08:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhBXHr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 02:47:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233025AbhBXHrz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 02:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614152789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JzbJ+kq4gpkDlKFfvomQoUYIATJ1yAfJmKzPdXPZkI8=;
        b=fvS+agpV8hPK72bYlW30cfi+oREDDD2317RJg2qObHD8xYlOL8KSeNCkoHwlh4fBsA6bHN
        JFTLLNyYFuin3DVCZP6eY+5oZs0r9ZSkgXQvMtDRAtW1i7HYh+65flwoxbfdFVJnlrFrhc
        5hHEZS8X0/Y16o7N4kOMaoKsv3FFUF0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-cfobt5JSOsiGy1ryy1rouA-1; Wed, 24 Feb 2021 02:46:15 -0500
X-MC-Unique: cfobt5JSOsiGy1ryy1rouA-1
Received: by mail-ej1-f70.google.com with SMTP id b15so488949ejv.4
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 23:46:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzbJ+kq4gpkDlKFfvomQoUYIATJ1yAfJmKzPdXPZkI8=;
        b=iZQeyMIF4xYSMuzQtEjPtwoNoXq6HZH5ufj6lXuYIfq6Mg21VPITK8Zm5EiAjkpRKn
         YidKKTJj+0wx+LaB1ILjPJIL1ByLTx1+f17qxYNjiaVM+wjKTgPpwK3dD9ptE+skyZDe
         UjDAsBCKYr7IUPqEN+dRnwwn4C2kaiPGbHvUZQmbuIoGiAshNPTm/i1WlDmbZYVlv5Hq
         qo4B5IojbLiCOJDZ5B26CVcDo1csPhYkPpOzZVPnR1Nb639qqadrLsO1x0OM8UMIkP0m
         HOh1KrzQRaivQA+wUmbvSZw+GQ88uYpiLY4nyXZvn8wFFHwV5MFNmdND0ode/dWwHy6Q
         JDbw==
X-Gm-Message-State: AOAM533v/kStnrPh9h/ZWf5moP64UoJyQ1a6o0Jq4Lq6nYlkijeTbW3Q
        V0l15e/9CM4v2KbM5JnwBbmo0cDnsi7IFVdDhrNnlLzvTKXWdvzeL5cY2BJTqlIfvdMJbPrMYPq
        UvjZWoS62T6Ia
X-Received: by 2002:a05:6402:402:: with SMTP id q2mr32153271edv.116.1614152774362;
        Tue, 23 Feb 2021 23:46:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzc29MARMVwpFj2qsR3J8KH2Koe88+3AOshjaAOPpWU8aAExOqc0e30qPF6XH92/fB1rFq+6A==
X-Received: by 2002:a05:6402:402:: with SMTP id q2mr32153260edv.116.1614152774205;
        Tue, 23 Feb 2021 23:46:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g10sm681107ejk.88.2021.02.23.23.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 23:46:13 -0800 (PST)
Subject: Re: [PATCH 1/1 v2] nSVM: Test effect of host RFLAGS.TF on VMRUN
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210204232951.104755-1-krish.sadhukhan@oracle.com>
 <20210204232951.104755-2-krish.sadhukhan@oracle.com>
 <a3cfdf3a-9f6f-76e5-3cb8-2aaf117e798d@redhat.com>
 <cedacbe4-6cb1-ac77-55eb-d28d4c818655@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1421c7ec-70a8-fda9-0ac0-e2f50a9b9211@redhat.com>
Date:   Wed, 24 Feb 2021 08:46:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cedacbe4-6cb1-ac77-55eb-d28d4c818655@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/02/21 21:28, Krish Sadhukhan wrote:
> I couldn't find any text in the APM that describes the effect of 
> unsetting EFER.SVME on the virtual VMLOAD/VMSAVE. Is this the expected 
> behavior of the SVM hardware or is this a bug in KVM and KVM should 
> handle this ?

The guest always runs with EFER.SVME=1 (it's part of the VMRUN 
requirements), so yeah, vVMLOAD/VMSAVE must be enabled only if the guest 
has EFER.SVME=1.  Nice!

Paolo

