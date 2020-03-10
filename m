Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97317F081
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 07:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgCJGcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 02:32:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60073 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725919AbgCJGcG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 02:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583821926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1yU8oUTA8/wnaOz9hoJioLzE4hVFWMjV/4+YfFPe8NY=;
        b=aZ3LCU7SduD5XEMiwKFoEifIBfoOmMeOA4uqX7fAg2KkJZXV8XyWGzAwrZ5k9uJaKI36c0
        hWqzo3WgyALMCjFq/cG6Q7IRGo1jrKqRnLy1UHX/NkE47sKK6VTl0RlHsTEoPUX/+Yu0g1
        58U5bzzgraNTLZs9a853e/kIAdbSzFk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-u4dUJXd8PVamha83rFUwwA-1; Tue, 10 Mar 2020 02:32:03 -0400
X-MC-Unique: u4dUJXd8PVamha83rFUwwA-1
Received: by mail-qt1-f199.google.com with SMTP id z5so4156163qtd.4
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 23:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1yU8oUTA8/wnaOz9hoJioLzE4hVFWMjV/4+YfFPe8NY=;
        b=thxJINYJSV/X3S7Z7QGmDpXM+DZ6MWz0n99WOSLGm8hjy15ckyQ9IoPkU6Jha8M4Gx
         zZqJ4LysU9dZgr4CW6/56W6Z0Idh/DjwVI9vu8Z9uSG6miB7KSMiDYmcLNWf+P4XmuTB
         axD9lLtp5LT723FWYu6PSkAq3Zqr9Oe4wpo/cTVnqqTFR9We1UJUswRsaovQnM/50EQp
         fJt3WAYSUHLrPK5yTdmLiYXlACGsAnTzb5zAoqYTGSa8ab5UtQ7eulKcn+9dgNycTh9o
         W0y02Ij6Lzek3DaIsKrv2VWV9rGDjgckW43E3XvDl2uYCZ8a9Q9873kh+sqU9DmkOoVi
         aRug==
X-Gm-Message-State: ANhLgQ0Il0o9x1+TdP+fYs0/SOhErTmIN2jD36sj7cl/tR7PRARh2wzQ
        p7gOXus/apfhIBiNx03AU5xnJpHkRfOA1O+GT4jyY/c8vtvTDix28V8Ui6A3Hof6XnUmYDTxItz
        iu/4OT2++Dsk+
X-Received: by 2002:ad4:510f:: with SMTP id g15mr17843673qvp.105.1583821923117;
        Mon, 09 Mar 2020 23:32:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuxiDdLJVlLKqFBw/p9Wp9h+eHv1I2YQjlDbjEPANoQ+DnOSPJfUC4oUjNeZIuVmyLRb0N5hg==
X-Received: by 2002:ad4:510f:: with SMTP id g15mr17843652qvp.105.1583821922918;
        Mon, 09 Mar 2020 23:32:02 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id e7sm14687548qtp.0.2020.03.09.23.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:32:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 02:31:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v5 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200310022931-mutt-send-email-mst@kernel.org>
References: <20200304174947.69595-6-peterx@redhat.com>
 <202003061911.MfG74mgX%lkp@intel.com>
 <20200309213554.GF4206@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309213554.GF4206@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 05:35:54PM -0400, Peter Xu wrote:
> I'll probably also
> move KVM_DIRTY_LOG_PAGE_OFFSET==0 definition to uapi/linux/kvm.h.


IMHO KVM_DIRTY_LOG_PAGE_OFFSET is kind of pointless anyway - 
we won't be able to move data around just by changing the
uapi value since userspace isn't
recompiled when kernel changes ...


> -- 
> Peter Xu

