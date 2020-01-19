Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D443E141F2D
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 18:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgASRRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 12:17:45 -0500
Received: from srw1.wq.cz ([80.92.240.241]:37608 "EHLO srw1.wq.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgASRRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 12:17:45 -0500
X-Greylist: delayed 1623 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jan 2020 12:17:45 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wq.cz;
        s=default; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender
        :Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dsx363sPKa04mZOjTOViTRoclhTrhKIB6YXGkUGA4ps=; b=NTvmUQ7T/x98J9bXgQQuM0XPKv
        5mdDpkPP8SIhnjJfTKhChQ8hA5b0iLTs9GW8FmCBLqIcJnajgJppu+5chNiSD0J/3Y0PjBg22eL5P
        4e42BmRyJa8KqOs4wdfv7RRhMJWRIiEfVy17hLjKa4h8CB1bCxumaEXhs9SpmNoxfz4E=;
Received: from fw.wq.cz ([185.71.40.210] helo=msc.wq.cz)
        by srw1.wq.cz with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <milon@wq.cz>)
        id 1itDmZ-0006rN-SM
        for kvm@vger.kernel.org; Sun, 19 Jan 2020 17:50:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wq.cz;
        s=ntm; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dsx363sPKa04mZOjTOViTRoclhTrhKIB6YXGkUGA4ps=; b=IYdpoHPFnF+RXc3djw/8sTg+4h
        ZWirJoW73aLoEV3JNWmucD6J6kUrTh8dn4WRINXMpVweAd/5l/BV7duOtZYw/+t4FyK96gcFcUhxZ
        xdcZHylXAL36jPhzfMgWlW+ZEGOKGcbYjlyubiXVqc9g4ze7o1U+GlHhYQYkiR2y4ASI=;
Received: from milon by msc.wq.cz with local (Exim 4.92)
        (envelope-from <milon@wq.cz>)
        id 1itDmZ-0005nP-AG
        for kvm@vger.kernel.org; Sun, 19 Jan 2020 17:50:39 +0100
Date:   Sun, 19 Jan 2020 17:50:39 +0100
From:   Milan Kocian <milon@wq.cz>
To:     kvm@vger.kernel.org
Subject: kvmtool: processes inside vm hang in D state
Message-ID: <20200119165038.GD2878@msc.wq.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I hope it's the right mailinglist, if not I apologize.

I can see strange thing inside lkvm virtual machine. The processes
stuck in the D state after some time (few days or few hours):

root@testvm:~# ps ax | grep D
  PID TTY      STAT   TIME COMMAND
   20 ?        D      0:00 [kworker/u4:1+xfs-cil/vda1]
 1072 ?        D      0:00 [xfsaild/vda1]
 3237 ?        D      0:00 [kworker/0:1+xfs-sync/vda1]
 3309 ?        D      0:00 [kworker/u4:0+flush-254:0]
 3461 pts/0    S+     0:00 grep D

After that the vm is unusable.

I tested differrent filesystem, different distributions with the same
result (latest kvmtool git: https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git)

Is there any way how to debug it ?

Many thanks.

Best regards.

Please cc me, I am not a member.

-- 
Milan Kocian
