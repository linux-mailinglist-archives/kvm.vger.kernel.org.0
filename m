Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C841E8740
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgE2THs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 15:07:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21236 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726829AbgE2THs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 15:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590779267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sj1og6Hwf3Hcvb9x+uY+l3GZoDhuJDM+q+4231YgpSA=;
        b=AvOk21z07nu2EW3YThqAhqL6/gV1WfAhnWeRhbacN3LnwIuMVwhwo/OrOsXIIb3x/j/yyN
        uVljY13UOSQFjmMvk58aVYAxlYjvxWujzDG5W1eAfvmsfmc5V+jOdIxqDveYUcjOGgbb/V
        pb0+THldp4uRoyOO7epomTAjzHMuuDY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-I-u4UY5HODC09q5k2ebHcA-1; Fri, 29 May 2020 15:07:45 -0400
X-MC-Unique: I-u4UY5HODC09q5k2ebHcA-1
Received: by mail-wr1-f69.google.com with SMTP id r5so983477wrt.9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 12:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sj1og6Hwf3Hcvb9x+uY+l3GZoDhuJDM+q+4231YgpSA=;
        b=VEHyiOHJoxZtI9bzx0XfeISJ1Dg2RtGYhHWd87GBQbccqI1I6aUxAp2Bq6V5Klrzu2
         VhnnFLmbMs2QxvrsbTK9EbdlgCzJLcyuqPwAAjIcQvwNRKFdWwSUNpOBBjbMY39oqxUz
         wRDrx4dxj/ZI6dl3QSrZLB2B1WXteCYYBZ5TfZWcvIk8bpceWcd+8fxzp0VnVGNTBgmb
         898VMDMry8xpNlkwbeO8LO39hKloNpepFBZctnAaM4QCHNrU0P+kTxk/1fm1NhhanPj0
         zIpSEgTsFk7qHXRcULxAmAhnq1E2DpZZiDvpm6yYlhduC7Rm8SohEffKzDZAXQCUGFVy
         HnFA==
X-Gm-Message-State: AOAM533bj+Sy1vRDndb9aDllDfEa8KkgHEGpAcMJS78wRXop5y3Yilza
        gZtJYkB1ehyiIHbWb/b8+aCmIystoU65U+SmhO5uN0Hcyg/GrDVhyU3lw5pEcUzcUe1btrrGF5B
        6VWtWrdOnAhfy
X-Received: by 2002:a5d:4404:: with SMTP id z4mr9192641wrq.189.1590779264294;
        Fri, 29 May 2020 12:07:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJkiQVQRTm18QU+h2D02Bj+MAqj5rinTPXbInhtXnOTLdFsdU3oA0YRnoOfJ7PgrsXkB8Vow==
X-Received: by 2002:a5d:4404:: with SMTP id z4mr9192627wrq.189.1590779264089;
        Fri, 29 May 2020 12:07:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id d13sm498222wmb.39.2020.05.29.12.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 12:07:43 -0700 (PDT)
Subject: Re: [PATCH v3 00/28] KVM: nSVM: event fixes and migration support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529175939.GC1074@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff010a6b-e67f-1b09-db7e-c0985f3fcfb5@redhat.com>
Date:   Fri, 29 May 2020 21:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529175939.GC1074@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/20 19:59, Sean Christopherson wrote:
>> [PATCH v3 00/28] KVM: nSVM: event fixes and migration support
> You've got something funky going on with the way you generate cover letters,
> looks like it doesn't count patches authored by someone else.  The 'v3' is
> also missing from the patches, though I suppose some heathens do that on
> purpose.

No, I simply had a draft of the cover letter ready, and when I decided
to include Vitaly's patches I didn't update the subject.

Paolo

