Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56434387C87
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 17:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350214AbhERPhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 11:37:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14542 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238479AbhERPhy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 11:37:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14IFYA98148886;
        Tue, 18 May 2021 11:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xcmSylA/4hUoFFzBr2LoBqnjvfn030uzm3Pt7CxycYs=;
 b=JxXOtaG0vMCFaIJbi/sn+LZvxTTOOCd3rODVUUSIG0MWgUiB36Wc3zkpxh/tfJVZxwb/
 jdyZLKsF8teVzdFcov/9feg4Zl9YdYskZMARpcanLI9gxIvx3ee4Sayj4Bxy7AXTW45Y
 ZqXY1Wel4F7ouhN5r2Q8Ekjkirw3u2ksHhb7ZqtTR0jb1X8pdYBJ0VrWco0fCQ2KiAZK
 EV9uLaRYkWo1pFLRTX3qlGGvtukl/w0FDMakI3iaAdJ54y5/JI8vxrId3Ojz38jUojpO
 OAlVsLU2UOJ1Oc5Lsmz24s+oBXIS9DH13xY1kz9oNcZ5TbYFpNI80aLwS3G2JBrovBQ3 LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38me9u4wtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 11:36:31 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14IFYiRD160652;
        Tue, 18 May 2021 11:36:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38me9u4wsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 11:36:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14IFZoW1016117;
        Tue, 18 May 2021 15:36:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7sk0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 May 2021 15:36:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14IFaQbR37093754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 May 2021 15:36:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33ED95204F;
        Tue, 18 May 2021 15:36:26 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C474E5204E;
        Tue, 18 May 2021 15:36:25 +0000 (GMT)
Date:   Tue, 18 May 2021 17:36:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/11] KVM: s390: pv: implement lazy destroy
Message-ID: <20210518173624.13d043e3@ibm-vm>
In-Reply-To: <20210518170537.58b32ffe.cohuck@redhat.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
        <20210518170537.58b32ffe.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SlwbSI_7HWxHxEdtH9xjyhEamKTw-7I7
X-Proofpoint-ORIG-GUID: 75XW01xijpZLMP_SZ34jtcS81s4v_6De
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-18_07:2021-05-18,2021-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=953 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105180111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 17:05:37 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon, 17 May 2021 22:07:47 +0200
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
> > Previously, when a protected VM was rebooted or when it was shut
> > down, its memory was made unprotected, and then the protected VM
> > itself was destroyed. Looping over the whole address space can take
> > some time, considering the overhead of the various Ultravisor Calls
> > (UVCs).  This means that a reboot or a shutdown would take a
> > potentially long amount of time, depending on the amount of used
> > memory.
> > 
> > This patchseries implements a deferred destroy mechanism for
> > protected guests. When a protected guest is destroyed, its memory
> > is cleared in background, allowing the guest to restart or
> > terminate significantly faster than before.
> > 
> > There are 2 possibilities when a protected VM is torn down:
> > * it still has an address space associated (reboot case)
> > * it does not have an address space anymore (shutdown case)
> > 
> > For the reboot case, the reference count of the mm is increased, and
> > then a background thread is started to clean up. Once the thread
> > went through the whole address space, the protected VM is actually
> > destroyed.
> > 
> > For the shutdown case, a list of pages to be destroyed is formed
> > when the mm is torn down. Instead of just unmapping the pages when
> > the address space is being torn down, they are also set aside.
> > Later when KVM cleans up the VM, a thread is started to clean up
> > the pages from the list.  
> 
> Just to make sure, 'clean up' includes doing uv calls?

yes

> > 
> > This means that the same address space can have memory belonging to
> > more than one protected guest, although only one will be running,
> > the others will in fact not even have any CPUs.  
> 
> Are those set-aside-but-not-yet-cleaned-up pages still possibly
> accessible in any way? I would assume that they only belong to the

in case of reboot: yes, they are still in the address space of the
guest, and can be swapped if needed

> 'zombie' guests, and any new or rebooted guest is a new entity that
> needs to get new pages?

the rebooted guest (normal or secure) will re-use the same pages of the
old guest (before or after cleanup, which is the reason of patches 3
and 4)

the KVM guest is not affected in case of reboot, so the userspace
address space is not touched.

> Can too many not-yet-cleaned-up pages lead to a (temporary) memory
> exhaustion?

in case of reboot, not much; the pages were in use are still in use
after the reboot, and they can be swapped.

in case of a shutdown, yes, because the pages are really taken aside
and cleared/destroyed in background. they cannot be swapped. they are
freed immediately as they are processed, to try to mitigate memory
exhaustion scenarios.

in the end, this patchseries is a tradeoff between speed and memory
consumption. the memory needs to be cleared up at some point, and that
requires time.

in cases where this might be an issue, I introduced a new KVM flag to
disable lazy destroy (patch 10)


