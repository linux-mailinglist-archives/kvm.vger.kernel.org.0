Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898D32A867F
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 19:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbgKES4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 13:56:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731799AbgKES4B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 13:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604602560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mmFXjTQW8k98jRyPd67FItQJTOEKBm9sgl7KN/g7W/Q=;
        b=MKim6JO15S+YMRd3QeSIddWtdMPl1mCpKn3jiBkeSUnxlD3VyeLdio8Wln6GzVJLvtR91w
        kWUqrC2c5SCBuox64sjVLkVewpf+WFUvpwF4rHT05TasZNFYm2zuRaAFQfASECt5k0uU7+
        28DgsiHZJrcxeOQMDFNbVhA7/skrl5s=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-kDknGU4IN3uqygQWpKcWfw-1; Thu, 05 Nov 2020 13:55:56 -0500
X-MC-Unique: kDknGU4IN3uqygQWpKcWfw-1
Received: by mail-qk1-f200.google.com with SMTP id 141so1526408qkh.18
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 10:55:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mmFXjTQW8k98jRyPd67FItQJTOEKBm9sgl7KN/g7W/Q=;
        b=uagA/nH7XhKAkssbgmrsybj5LLzsWpZMcRlp3VvVjrXtGOdeZGR4ncjmzUQKddfABK
         eleIwM2TmYJtJiIU1l1fNXmypzBQ5r+gvLOQaxecN3HiOYpbOt0Of13NLCWnWz9dxSmZ
         bGM1tLIGZLpvBFqIM8wE/p2wdjD+Dc1JPRoh/fbBTQ4Vbr3jGfQQYg0Lfxc52BfsNaaM
         Bx5/Ya3VfBI9JMkiL4MgLlLC9cE1jrhW6p9CSuZTo+94SSqQWhEzCjQ/Xfb39xuLY6dJ
         qritTGNJkV0r6LxnhGAzuVbu8M2ogemZesIFP93HLkWGUec6kRcNU06uw13CX1Nvl6So
         dBsA==
X-Gm-Message-State: AOAM530XJhFG4m+qx/DKQJnG5XobC/UiKxsmgUiakajtwBoNlkHr8tnq
        lNnJOA8varYUys6/Y9gWJLvG+cuBitslcioPpnkWFzQQzVTVjGJazmOtwXtyvKK6u3Z6qak7qLP
        PIvGgCpEQL0Gn
X-Received: by 2002:a0c:ef02:: with SMTP id t2mr3387182qvr.7.1604602556368;
        Thu, 05 Nov 2020 10:55:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxF2FV9uUkY8Prkrm2ddge89imC169aGPdU6LYnHIgcOOj2ekGSNQnw9N1Xs220Sgnd204tUw==
X-Received: by 2002:a0c:ef02:: with SMTP id t2mr3387168qvr.7.1604602556206;
        Thu, 05 Nov 2020 10:55:56 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id e186sm1175318qkd.117.2020.11.05.10.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:55:55 -0800 (PST)
Date:   Thu, 5 Nov 2020 13:55:54 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH 00/11] KVM: selftests: Cleanups
Message-ID: <20201105185554.GD106309@xz-x1>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 10:23:46PM +0100, Andrew Jones wrote:
> This series attempts to clean up demand_paging_test and dirty_log_test
> by factoring out common code, creating some new API along the way. It's
> main goal is to prepare for even more factoring that Ben and Peter want
> to do. The series would have a nice negative diff stat, but it also
> picks up a few of Peter's patches for his new dirty log test. So, the
> +/- diff stat is close to equal. It's not as close as an electoral vote
> count, but it's close.
> 
> I've tested on x86 and AArch64 (one config each), but not s390x.

The whole series looks good to me (probably except the PTRS_PER_PAGE one; but
that's not hurting much anyways, I think).  Thanks for picking up the other
patches, even if they made the diff stat much less pretty..

-- 
Peter Xu

