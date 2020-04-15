Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB731AAB7F
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414572AbgDOPLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 11:11:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41579 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393140AbgDOPL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 11:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586963486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C0vYOJO4v4REcjYahYU+BEluO/YhMr3LnC3HEtpWFrM=;
        b=ilCOJ9Fzd+uiHsuyydmcRv7p2GZgVotR3LhndAw4W7w6GxeXCIrWUQImdpopEiTb1BW3my
        0g2QxNrrP8W/RyKZVi6ZPdLD3z+VzbgMz1t/b1Cx+/6wywPNv0va6nMNQa4nKztb4bJJSs
        UaLAdS+Js1cRsx0JXWzPYQXxgTyFcqc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-oyZFeW9TPf-oO-wu8TUVEQ-1; Wed, 15 Apr 2020 11:11:24 -0400
X-MC-Unique: oyZFeW9TPf-oO-wu8TUVEQ-1
Received: by mail-wm1-f72.google.com with SMTP id y1so5924925wmj.3
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 08:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C0vYOJO4v4REcjYahYU+BEluO/YhMr3LnC3HEtpWFrM=;
        b=hucB1CGtMLCfG/jWp7jOkfArJBUfYVIjSWikAoZqG9erau0cW99ZHCazkb+uhgM8sE
         7220NOgSMCFPB85K5JAR4VEiXtbZFltL4NGPHxjHvHO0dxKxWUmjFbsqCuH4Lhvxxds/
         XzpSg1+/SqgN4ENqz0YrtcjiM8SW8AMpCXOrWuozcWiRqu+okXfhmXtdbQdRDfhXrH/e
         5dlZ0fhKeN/IG7nZ0BuW05iSeh5B5fhIpWC7MybODH9X0t4ojnBCd4hPsJNmYdNJXFSC
         EBkeQcjCkt/JDe/re+oOi6J+jcds5mA+IkuW1MGj/uScp+LyLGj9vXi7BAMyDuiQBomk
         uV7w==
X-Gm-Message-State: AGi0Pubkh7XTE+ijVxzJSYWKgL2VNLD2kCOn8R22XxTulL6fzyJb/sm9
        1VqKK4ne8KlNAn3ysJ/oPLS8ik40JwnggRFIY19yPmoSWfrQBU2Itqqn9YH856UdHdoWWHBjtZ+
        g3ztSYxCQfL2K
X-Received: by 2002:a1c:7301:: with SMTP id d1mr6033184wmb.26.1586963483565;
        Wed, 15 Apr 2020 08:11:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypKABLDLSsReEBMN+X/RLahvOhdo6qaiJnvnlmfjlbWNKdq2bnrmCnT0QXYbj9B/mxQdNLqTZw==
X-Received: by 2002:a1c:7301:: with SMTP id d1mr6033166wmb.26.1586963483345;
        Wed, 15 Apr 2020 08:11:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id h2sm23766953wmf.34.2020.04.15.08.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 08:11:22 -0700 (PDT)
Subject: Re: [PATCH 01/10] KVM: selftests: Take vcpu pointer instead of id in
 vm_vcpu_rm()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-2-sean.j.christopherson@intel.com>
 <b696c5b9-2507-8849-e196-37c83806cfdf@redhat.com>
 <20200413212659.GB21204@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2def9fa-375e-d677-32a2-b1bb0e8d3fb6@redhat.com>
Date:   Wed, 15 Apr 2020 17:11:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200413212659.GB21204@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/20 23:26, Sean Christopherson wrote:
> FWIW, I think the whole vcpuid thing is a bad interface, almost all the
> tests end up defining an arbitrary number for the sole VCPU_ID, i.e. the
> vcpuid interface just adds a pointless layer of obfuscation.  I haven't
> looked through all the tests, but returning the vcpu and making the struct
> opaque, same as kvm_vm, seems like it would yield more readable code with
> less overhead.

Yes, I agree.  This was in the original Google submission, I didn't like
it either but I didn't feel like changing it and I wouldn't mind if
someone does the work...

Paolo

