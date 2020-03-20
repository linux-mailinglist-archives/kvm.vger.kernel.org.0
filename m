Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6945A18D30E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 16:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgCTPhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 11:37:55 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53308 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726144AbgCTPhy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 11:37:54 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 89B344128C;
        Fri, 20 Mar 2020 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1584718671;
         x=1586533072; bh=VqYrnn/X2CeMed9ITJDVjqk6MSDuOUjwTrG6eHUxqeA=; b=
        hcroZSm1D4Pl/wQr4rcUpriOjynV/xR3QgDidB7R5vU/SHHTpS+nOJ4f0RgjjKjN
        HEAoLhHqzY7dlHejD4mHzSOFDIfY3VONNHGsmcWoiezEWLAzcVrhcC3xSAlZvdXK
        e7XtLCMhS6epdOoCIwZ5C2Z0snQLPAxBSRZJMxbHwc4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d5Idnsge28k3; Fri, 20 Mar 2020 18:37:51 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 70C04412EA;
        Fri, 20 Mar 2020 18:37:51 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 20
 Mar 2020 18:37:51 +0300
Date:   Fri, 20 Mar 2020 18:37:51 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Cameron Esfahani <dirty@apple.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] Add support of hvf accel
Message-ID: <20200320153751.GF77771@SPB-NB-133.local>
References: <20200320145541.38578-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200320145541.38578-1-r.bolshakov@yadro.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm sorry for broken formating in the cover letter. Here's a reformat at
your convenience.

HVF is a para-virtualized QEMU accelerator for macOS based on
Hypervisor.framework (HVF). Hypervisor.framework is a thin user-space
wrapper around Intel VT/VMX that enables to run VMMs such as QEMU in
non-privileged mode.

The unit tests can be run on macOS to verify completeness of the HVF
accel implementation.

Regards,
Roman
