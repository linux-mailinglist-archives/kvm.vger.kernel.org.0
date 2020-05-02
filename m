Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F481C270A
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 18:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgEBQmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 12:42:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728234AbgEBQmI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 May 2020 12:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588437727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OidOSfoLTFcT8l45mrEaIKuRu8kYn+JXy7OweRfj4xs=;
        b=c88kiegHH/jXsiqjiE6Ht/hYIVX7XK+zczdcHqOBAbhSbKFi4W1SAj5HqACHO5zKMXlgNf
        MABx/P06pAZnBg+5AT/F1gWYvIkMTY+5j7liewCRFU3tbNk0kKmNOn217cTrkQNsQUjcId
        cy7m7CYQy+NUW0YVVq/3XKbqJ6xOGy4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-uCPCqADeNCuAoAx-ggNurA-1; Sat, 02 May 2020 12:42:06 -0400
X-MC-Unique: uCPCqADeNCuAoAx-ggNurA-1
Received: by mail-wm1-f72.google.com with SMTP id b203so1515458wmd.6
        for <kvm@vger.kernel.org>; Sat, 02 May 2020 09:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OidOSfoLTFcT8l45mrEaIKuRu8kYn+JXy7OweRfj4xs=;
        b=kT+60R/MTSQcK6IikJgS126aQESHsG5XYUXTo+CMh/B7eXWvWx/OMWPgrImDFXqtfO
         Y3BQQ3X8UDtudVcKSDbxNmF07bCPEAwPqiPLEtcyYH2azQ1WS7iu24yNVIuGpnKZy+v2
         TSBH8u1Sl7XLZdSxembxuYAQBYGp4GHbFaqBr+932WTrfy4GvgOOTaW0X/wG08wOgwY0
         RGxVDwlXV8r/q01N0MaT/frHfPM15uXhC6jHkXrpnOus4JvxBk+w0XLPQsWrjmqFLaWL
         TWdrw4XcmKZOHkPiVSjvimzw+abbXfASWh0SxIkAzjdfbu3oWBU/9YqDAWLwuUEdInxE
         plig==
X-Gm-Message-State: AGi0PuYzzXUBDYu+Wz6jv/B9x+DEYE71mRPDeMfzqZvsBRRG7e92P66L
        t/ENoAW52/iQAaS5s0ULFtkQNs/7CDskJoVwtNwk0JmY9lLuhCsL0S4PtVwuvSuJ5Otg+uqHRIl
        fqbUMoID0Besd
X-Received: by 2002:adf:ce02:: with SMTP id p2mr9893076wrn.173.1588437724965;
        Sat, 02 May 2020 09:42:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypJUKirEiYTqHQbj1N49RThKk1BCWQb1DCNrF6PMtg9FJiFwHPqNHMIAZlRE7BsQ8uI/4Gwzgw==
X-Received: by 2002:adf:ce02:: with SMTP id p2mr9893066wrn.173.1588437724734;
        Sat, 02 May 2020 09:42:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1000:6128:564:d837? ([2001:b07:6468:f312:1000:6128:564:d837])
        by smtp.gmail.com with ESMTPSA id d7sm9923543wrn.78.2020.05.02.09.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 09:42:04 -0700 (PDT)
Subject: Re: AVIC related warning in enable_irq_window
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
Date:   Sat, 2 May 2020 18:42:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/20 15:58, Maxim Levitsky wrote:
> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
> kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
> however it doesn't broadcast it to CPU on which now we are running, which seems OK,
> because the code that handles that broadcast runs on each VCPU entry, thus
> when this CPU will enter guest mode it will notice and disable the AVIC.
> 
> However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
> which is still true on current CPU because of the above.

Good point!  We can just remove the WARN_ON I think.  Can you send a patch?

svm_set_vintr also has a rather silly

static void svm_set_vintr(struct vcpu_svm *svm)
{
       set_intercept(svm, INTERCEPT_VINTR);
       if (is_intercept(svm, INTERCEPT_VINTR))
               svm_enable_vintr(svm);
}

so I'm thinking of just inlining svm_enable_vintr and renaming
svm_{set,clear}_vintr to svm_{enable,disable}_vintr_window.  Would you
like to send two patches for this, the first to remove the WARN_ON and
the second to do the cleanup?

Thanks,

Paolo

> The code containing this warning was added in commit
> 
> 64b5bd27042639dfcc1534f01771b7b871a02ffe
> KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1

