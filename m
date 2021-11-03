Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4585E443DE1
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhKCH7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhKCH7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635926203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LssBQDxynhbfvzN5x2P4avrYJEkv+IZ5dgH9H1mj5ic=;
        b=ETqKy4GoA77rA61R2Tx/0W+ID+IAI1cSg998vgHSv9Y/J0tGPm24komI2EBYcajUg5d7g1
        XXFsZh6jXMkmHPLyMvpLGYW6v5du1ovgtQpAMMDR2Jxn0QKQgSzHGQcR+g66GXK8EVsEQO
        zdjFr0x1EKJXwQoqcWq0D6qlxLAzPUc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-1u5_E8vVNTKGRRvOSUrZ7g-1; Wed, 03 Nov 2021 03:56:40 -0400
X-MC-Unique: 1u5_E8vVNTKGRRvOSUrZ7g-1
Received: by mail-ed1-f70.google.com with SMTP id y20-20020a056402359400b003e28c9bc02cso1706687edc.9
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 00:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LssBQDxynhbfvzN5x2P4avrYJEkv+IZ5dgH9H1mj5ic=;
        b=oBcRzn/MQ5PeRs0xgs89XXbh9pvg1Y9AGQmLxONXBNwF2mtGlXR6LIfelnJYyTJQSk
         8/diRqyXIOGWS0iUNuQ7CaJ8Ho6WT4YCaoMXJ0uYJll3RveYkUPWB3WqAqVYzT1SI5mj
         kdiorZubRsohfAUr1XxDBqcYWfOPsj8mLncVUTepmE2fBVxeON6S0Fy+sPH+rfBZjx+6
         i9qKZZ9/+Dw92dkOu/PwduZt5DLR3t1fpTmLsCfcQXEjKLe2AaB6j3dcPld/yO/85ITD
         QZ/mQqqGpuCtSeH+IdPP/3o1WOpEYGDbMX+4xSXqRfpYSu03rdAMqWSkqcbN7hII/Ga9
         PsBg==
X-Gm-Message-State: AOAM533i5ObqUEoFO+jO9UtvgPGo9cP7ECRfFmCsIE07q9r9a3U3Plhc
        T1bUjP36Zb98uqP/DmtOhTxH0SU4PktRNVc2RaXm4fijkO2710fiobwKDJkkFI8xkVhqwbV82PN
        RSQX7KMjUQ2gB
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr58484103edd.13.1635926199313;
        Wed, 03 Nov 2021 00:56:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl7lokiag5d7It+1k8Y/b4V9d9Bqx6swfrlwcRLGow9Lf8oQBEp3ugQdglmefjVqgI3FP9sQ==
X-Received: by 2002:a05:6402:268f:: with SMTP id w15mr58484090edd.13.1635926199205;
        Wed, 03 Nov 2021 00:56:39 -0700 (PDT)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id gv34sm680460ejc.104.2021.11.03.00.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 00:56:38 -0700 (PDT)
Date:   Wed, 3 Nov 2021 08:56:36 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
Message-ID: <20211103075636.hgxckmxs62bsdrha@gator.home>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
> +
> +#define VIRTIO_ID_PONG         30 /* virtio pong */

I take it this is a virtio test device that ping-pong's I/O. It sounds
useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
find it in QEMU at all?

Thanks,
drew

