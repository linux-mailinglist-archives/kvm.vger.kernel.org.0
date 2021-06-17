Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7913AB27A
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 13:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhFQL0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 07:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232577AbhFQL0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 07:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623929038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeoOEjtdTbZHikE6qVHZkIHtsqJ8oL1MWdn59al3yJU=;
        b=QPOshvNSHaHMRlCs/JLASRIRzg6IzS1axSTawZFHWQ7I3VLm1+WbR/58jk9N1C/WgYw62I
        g3k775BjI9nF5FtOg00KGs0MexHgVchuTcdmCD8iJ3S+pyGHquveDk19Pu4q/vLJlU1NKZ
        oPM/u9o9xGnNDfWS0ViWibD/iN39T3U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-R6I6JnwvNEKkTtg0MDXjIg-1; Thu, 17 Jun 2021 07:23:57 -0400
X-MC-Unique: R6I6JnwvNEKkTtg0MDXjIg-1
Received: by mail-ed1-f69.google.com with SMTP id g13-20020a056402090db02903935a4cb74fso1330717edz.1
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 04:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QeoOEjtdTbZHikE6qVHZkIHtsqJ8oL1MWdn59al3yJU=;
        b=N5zONty299TO9Z5o3l7eVzetg8lHZR+U1gJgeW8Fph54Yb9mpdCpNbwzbYusULum0C
         kzyBr9JcbnNQHKsApHV4eOmI/0+5ML9MZgVZEB8gDpTtpc9+ySd1i+y1rLn9LN+cAxmA
         zcalXLscXO3zsJIbLxq/Wn0PknGsuQ7cs9hYzwVe8eRJwU4kaWA5b4gjb3+VmZpUDkYD
         YU39IijNSy3T5fv0VVkpe4NpLEY8d10Uw9gHaa0wMK3pTDpwWdoiMYmmoQTYHzA6qn0O
         GIJJa707QJEoxqm31w6hSXQ42ZW4+EVZyan8a5Jwy+MWBOvOtYaGHxUSwGuhTH0Gd4ro
         7pwg==
X-Gm-Message-State: AOAM532ycnr3r8eAj9j5MIVnHnjANA+aHWx347OH8hFryzZ0cjy76K+1
        93pn0Cm/la26B/HoovAKMBsBaiSk1HO88w0yetqsyM/YO2C7MzitFh2gopdbybw+vhElAW3Vlle
        r+M4ABypHdxAp
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr5799067edd.228.1623928793194;
        Thu, 17 Jun 2021 04:19:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc8lc8kbfFsQbKsVnuEADgPqEmYVAvmC/1IvjtxjrXOO4gKYpFUgt0NPkDolV15GoZuo9rTg==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr5799027edd.228.1623928793011;
        Thu, 17 Jun 2021 04:19:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e18sm3537900ejh.64.2021.06.17.04.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 04:19:52 -0700 (PDT)
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com>
 <YMrmqOxDWJ2/8sfD@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be506135-5bc3-31bd-1b20-063f01f41df1@redhat.com>
Date:   Thu, 17 Jun 2021 13:19:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMrmqOxDWJ2/8sfD@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/21 08:07, Greg KH wrote:
>> The statistics data itself could be read out by userspace telemetry
>> periodically without any extra parsing or setup effort.
> Do you have a pointer to userspace code that can do such a thing that
> others can use?  We do not like adding apis to the kernel without at
> least seeing the user of those apis, especially for complex things like
> this.
> 
> Ideally you would include some library code in the kernel tree itself
> that everyone can use for this for their own programs.  You have
> provided a test which is great, but how do we know it works for "real"
> usages?

I am pretty sure that Google is using this internally, but we are also 
going to work on QEMU and Libvirt support for this.

As for the rest, thanks for the review---I'll let Jing act on it and 
only add my own remarks in a couple places.

Paolo

