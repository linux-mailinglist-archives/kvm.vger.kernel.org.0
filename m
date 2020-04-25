Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1481B8449
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgDYHs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:48:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42819 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYHs2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 03:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587800906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+lm7UGNtVQ/9rx+IjjaysXcfjKjoPvyljZwJ/cj3g/k=;
        b=KeFYmYxjw/SpsWQ7JcdnFP0A4u5L1ihdBE+G44h7jLxiGnmf71Etrc7QgU4TGE8NXLYo0H
        j2UBPJokzVQg2ge5VyzKsvypRo3BXgrnp6kcz55dGe0/ph0GRcdNq+QdVdmmlZ3D2Ea0wS
        X/RQCN+EOGmxMUOa+KU3BjtYY0x0QTk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-3GomDAgmOq64X15Kc9fQkg-1; Sat, 25 Apr 2020 03:48:19 -0400
X-MC-Unique: 3GomDAgmOq64X15Kc9fQkg-1
Received: by mail-wr1-f71.google.com with SMTP id a3so6358769wro.1
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 00:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+lm7UGNtVQ/9rx+IjjaysXcfjKjoPvyljZwJ/cj3g/k=;
        b=VuJseXWN3uzJO9P5QDs9P3dcyRmmeMYrsWxz/VuxDHNcoiHRIbs7pTkgjVuXH2fvT9
         udgfaZUHjHU0pwTkT+8QLgSL9z3f2xjSO47wpAhIO5USzRA5AERV9tNQbP5s0fIYv0QZ
         IQZPcetdEbeQhm9SHOnO7Ja2PCVjuihHLV8cXQ8irxfaID67JMlrfR0wfBndv2HX6BV+
         qi6m6YEXyQoqMTeJKKoe24YJYgzH57ZslRHvDvBCoh1EC+PDmJJt60qVc5VeJ0bmDIOr
         9CR4ggcioBUxSJwj9TWL3djixA7Qcwy09YUDgW+tCIOY9MsBIy1X8g8wKm/mB8MVmJbH
         xqyw==
X-Gm-Message-State: AGi0PubvFSaFBfso+P9/z+sTShhTObMMDuqaWBl1epxDosYGq//rn04w
        2rBIIzko/8yhzoIL8yuQgv0mp5wKCxQgG6CGg7cwufJ/vpdfOyhPhcB9+oKZRUv+LDQB5FkyhvD
        CX9xUcP97VEwx
X-Received: by 2002:a05:600c:220c:: with SMTP id z12mr14403661wml.84.1587800898698;
        Sat, 25 Apr 2020 00:48:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypI2racS5mj+0NM5MCd6RBG4jVkFYQMJgRtKqSAC7ooMySFxgT5VZf7gBc7p5o54fJ5wHWSrgg==
X-Received: by 2002:a05:600c:220c:: with SMTP id z12mr14403646wml.84.1587800898515;
        Sat, 25 Apr 2020 00:48:18 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id a10sm755359wrg.32.2020.04.25.00.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 00:48:17 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
 <20200423190941.GN17824@linux.intel.com> <20200424202103.GA48376@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1c0ba71-1c5b-a5b7-3123-7ab36a5c5c74@redhat.com>
Date:   Sat, 25 Apr 2020 09:48:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424202103.GA48376@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 22:21, Peter Xu wrote:
> But then shouldn't DIRTY be set as long as KVM_DEBUGREG_BP_ENABLED is set every
> time before vmenter?  Then it'll somehow go back to switch_db_regs, iiuc...
> 
> IIUC RELOAD actually wants to say "reload only for this iteration", that's why
> it's cleared after each reload.  So maybe...  RELOAD_ONCE?
> 
> (Btw, do we have debug regs tests somewhere no matter inside guest or with
>  KVM_SET_GUEST_DEBUG?)

What about KVM_DEBUGREG_EFF_DB_DIRTY?

We have them in kvm-unit-tests for debug regs inside the guest, but no
selftests covering KVM_SET_GUEST_DEBUG.

Paolo

