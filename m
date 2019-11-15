Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79EBFDAAD
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfKOKGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:06:36 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:45985 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfKOKGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:06:35 -0500
Received: from 79.184.253.153.ipv4.supernova.orange.pl (79.184.253.153) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.292)
 id eaf467d23101dae7; Fri, 15 Nov 2019 11:06:33 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, rafael.j.wysocki@intel.com,
        joao.m.martins@oracle.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/4] cpuidle-haltpoll: ensure grow start value is nonzero
Date:   Fri, 15 Nov 2019 11:06:32 +0100
Message-ID: <2090510.mhlLnX9yIq@kreacher>
In-Reply-To: <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com> <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, November 6, 2019 12:54:59 PM CET Zhenzhong Duan wrote:
> dev->poll_limit_ns could be zeroed in certain cases (e.g. by
> guest_halt_poll_ns = 0). If guest_halt_poll_grow_start is zero,
> dev->poll_limit_ns will never be bigger than zero.

Given that haltpoll_enable_device() sets dev->poll_limit_ns = 0 to start with,
I don't think that the statement above is correct.



