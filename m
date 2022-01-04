Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6022C484656
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiADRBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiADRBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:01:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63461C061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 09:01:06 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v16so31867459pjn.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 09:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zxnQMMKB3ueHf2wBen6zOg5wApyRhjX26rHhTLQTBjU=;
        b=PjwzE7zvr2TjaB0va2PwZDILOrlejdu8wY0aEXn6vRvcpHlEsqFmxU8mJm/qFfrTmW
         d846Q5yALrTNoWMOYDUPS7qaMeI156yVvc4fLYTq+IdpjRcDKZmNYcNHvu2DBP3b5kYk
         TtWTYsX0oH5Hq/yb6ODOcwm2yWVOji95Ergp2iEd3eXqbEv4X+9xPmQq2ks2/WCiqywT
         7vjKXG+xFOPY7HpgCwvrL3eXmViJ9oUkmJB+MIjCItGczvdCxzSyMpoXrPaMb2KBCSTY
         7WSKIutOMaVuTkmUXPwhb69ofgkmcNo0Sv/q9xPJSz2BowhGjWLpBT6UT13daU23hLy1
         HBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxnQMMKB3ueHf2wBen6zOg5wApyRhjX26rHhTLQTBjU=;
        b=Zbsf/yq9oqDmZ1US6ljAzVaMdwI0BaiZbBpwsteNv45ygLtlnt7FruugLBVTo06Ipm
         apcqHm4y/9p1LK37KAWOH+u5m4pM9CFTfLGQaCFJvQjcNVGV06vemnPykMAMT6kAWLZZ
         p5KYaMF/kQojAX650ZA2cLYa9J8WfsMOx4D3LRJBI/jhTkRhlytHuGmUG2+8kWLiXWr0
         gXS1FgRjWvML0CX20cTix1Zjh+t8JM1BG8encpwChr/cbA2Ryu3mFS0sEnPZLLZi58qr
         dWDO0je2pWhiWJlN23kKnOXoLYIQZ1Ap8wrmN7+pNxfhLz7uDx0R8Ijf0Ky2JxJ5hhEY
         waFg==
X-Gm-Message-State: AOAM533xPVETjmoIEk1BpgtEuF5kAwWRqM3G5FooS7TrmYUf15NMaj9Z
        +fvt2fhvYOingxUZbIA7JBKZTg==
X-Google-Smtp-Source: ABdhPJw0UhFbuuZvkubuq8SuQFiBXNeXLVR4vh0jrtx8BBhIlhHg/qTZMfCWO0vmmGfQTBJxp7lNdg==
X-Received: by 2002:a17:903:41c6:b0:149:49fc:315c with SMTP id u6-20020a17090341c600b0014949fc315cmr49606374ple.41.1641315665632;
        Tue, 04 Jan 2022 09:01:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o11sm43559086pfu.150.2022.01.04.09.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:01:05 -0800 (PST)
Date:   Tue, 4 Jan 2022 17:01:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, agraf@csgraf.de
Subject: Re: [PATCH v2 0/1] KVM: Dirty quota-based throttling
Message-ID: <YdR9TSVgalKEfPIQ@google.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 03, 2022, Shivam Kumar wrote:
> I would be grateful if I could receive some feedback on the dirty quota v2
> patchset.

  'Twas the week before Christmas, when all through the list,
  not a reviewer was stirring, not even a twit.

There's a reason I got into programming and not literature.  Anyways, your patch
is in the review queue, it'll just be a few days/weeks.  :-)
