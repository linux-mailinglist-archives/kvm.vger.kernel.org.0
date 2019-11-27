Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6414410AFBC
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 13:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfK0MoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 07:44:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37338 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfK0MoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 07:44:18 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iZwg3-0001lQ-UY; Wed, 27 Nov 2019 12:44:16 +0000
Date:   Wed, 27 Nov 2019 09:44:12 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Gradus Kooistra <gradus@gemeenteoplossingen.nl>
Cc:     kvm <kvm@vger.kernel.org>
Subject: Re: Guest system gets random high io-waittime. Restart virtual
 machine resolves the issue
Message-ID: <20191127124412.GE288840@calabresa>
References: <1778214032.3890788.1574855501447.JavaMail.zimbra@gemeenteoplossingen.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1778214032.3890788.1574855501447.JavaMail.zimbra@gemeenteoplossingen.nl>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 12:51:41PM +0100, Gradus Kooistra wrote:
> Dear Sir/Madam,
> 
> 
> We are running KVM on Ubuntu (16.04). Sometimes a guest machine is getting a very high IO-Wait time, but there is not that much of disk-activity needed.
> Restarting the KVM solves the problem. At the same time, the other guests dos not have the problem, running on the same machine (so it is just that one virtual machine).
> 
> 
> We got this issue now for almost two years.
> 
> What is the best place of make a report of this issue?
> 

Ubuntu launchpad would be the best place. I would say the qemu package is the
best option for now.

https://bugs.launchpad.net/ubuntu/+source/qemu/

Regards.
Cascardo.

> 
> Met vriendelijke groet, 
> Gradus Kooistra 
> 
> 
> De inhoud van dit bericht is vertrouwelijk. Als dit niet voor u bestemd is, wordt u vriendelijk verzocht dit bericht en eventuele kopieën daarvan vertrouwelijk te behandelen en te vernietigen en dit aan de afzender te melden.
