Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5B168549
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgBURnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:43:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45258 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726082AbgBURnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 12:43:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582307019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DRklp/EGbzKFbnLcWYfCTJYwspK96XjQokoDYirC2jo=;
        b=Zq5loLRMhapr8Z6ukvadvkVrSgGgxRg5TF6t/38e/eFh+59MoFCMjjk48tjoRLAOxbIW1Q
        WG6cigCAPc0m6yp9g303rQXWg2OnjDD5cDEtdkMcouYkd7Yj/gHrUWQXfmv2a9P6bePCXs
        AL0aGnkBqvWhrgExa98bYL4qkmerXEk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-5QMRynWEOsO3ZQzn7XhBTA-1; Fri, 21 Feb 2020 12:43:38 -0500
X-MC-Unique: 5QMRynWEOsO3ZQzn7XhBTA-1
Received: by mail-wm1-f71.google.com with SMTP id 7so905124wmf.9
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:43:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DRklp/EGbzKFbnLcWYfCTJYwspK96XjQokoDYirC2jo=;
        b=TNWo9jYpjJm7y1B/pahQHJQBVkFvfnci8t42nUHxzuVFtiyI6aGhhlLBpwxKfnnGwh
         nu2c+/6KnKnwzuOKPH3n0N6kKTqW3yU7OJ+eNuWdDy4SlhbEMZM5og2rn1HAaOyDwDu/
         cv0GF/C38E/lgOmDA9uJe361yXEgo/vVYNFMXlpprQCP06HDXc1tE3D0WVzV2+EWaVNW
         J4rjSrItEVxF2omxT3+VkXc4IqMNI3zDx05IvnxMa0gQt5+5t/TlH37k9BXrZ5E7wwfl
         kxafzBaGbraHP9ZqEjtZ8gp0LHSav146Xt5iThiKMwbjYiKoYv/Y1gPlYNkP9gn5/3FU
         OgMw==
X-Gm-Message-State: APjAAAX/RdtmfFH9FhpF8XJsNpwOdOgZqIqk/5Jn1hcabVyKxRECxP4g
        4CtlLEgYfGC+LHT49QeYv1TR9SjFIUBPoto2GDdclpMpSVLp6REH8To0XCMjazqKeDzwQ1hLbfl
        wU1rD+Y2WW/m0
X-Received: by 2002:a5d:4289:: with SMTP id k9mr51196990wrq.280.1582307017029;
        Fri, 21 Feb 2020 09:43:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2hj716qxeeRUnhWk7oLWJU5fIlTs2+zZOl+uuyj1LRQkzfullhSLke4OG8g9MBweopRblWg==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr51196974wrq.280.1582307016828;
        Fri, 21 Feb 2020 09:43:36 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id l131sm4908318wmf.31.2020.02.21.09.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:43:36 -0800 (PST)
Subject: Re: [PATCH v6 14/22] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-15-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1467b8cd-3631-b5da-b285-dbdf31b75af7@redhat.com>
Date:   Fri, 21 Feb 2020 18:43:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218210736.16432-15-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 22:07, Sean Christopherson wrote:
> -sorted by update_memslots(), and the old
>  	 * memslot needs to be referenced after calling update_memslots(), e.g.
> -	 * to free its resources and for arch specific behavior.
> +	 * to free its resources and for arch specific behavior.  Kill @tmp
> +	 * after making a copy to deter potentially dangerous usage.
>  	 */
> -	old = *slot;
> +	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	old = *tmp;
> +	tmp = NULL;
> +

Also: old = *id_to_memslot(...).

Paolo

