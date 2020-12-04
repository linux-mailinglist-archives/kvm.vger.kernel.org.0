Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501972CEF0D
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbgLDNw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 08:52:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25954 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbgLDNw4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 08:52:56 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4DWNbr014999;
        Fri, 4 Dec 2020 08:52:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2aywq7EznNVwW00nCia64dO+HCm8E9XQxwYo7lEOtkE=;
 b=J48rnuTPEceBt7Jt0NaF9FbT2hBslMODIl8ev01clvlA1YrrGimkeBAppZoDhxs+omje
 jCUkUSggRNl4uE3Eoz5/0v9vl1GwvoAMHxizp6bbtY402dv0c18ezrCnpDLyO51OxVtp
 yTz+W/mb1fHUIrfcTpkJJeQ5Mo+Kcy5d2QFHpJ0sC+jgKuWqomV/tY/IlIDyAphB3Jdy
 ZCMwcu14d9mH/X6McnBufbbQ7LQ2Vqm3Hf3hNRGfCoWOx0ZA2J/jfMWEJpDpLA2H9MyL
 p1dbAROAQ/xSQOOVRl7bqhmalTX4GGuZvmVEdwc40l6WXhrYru/C9DqgmLSICFDCuM4A qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3577435akv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 08:52:01 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4DWg6A015648;
        Fri, 4 Dec 2020 08:52:01 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3577435aj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 08:52:01 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4DmDx1030498;
        Fri, 4 Dec 2020 13:51:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 354fpdd2u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 13:51:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4DptwZ8061498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 13:51:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBEE752059;
        Fri,  4 Dec 2020 13:51:54 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.41.218])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id D67155204E;
        Fri,  4 Dec 2020 13:51:53 +0000 (GMT)
Date:   Fri, 4 Dec 2020 14:51:52 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        mdroth@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, thuth@redhat.com,
        pbonzini@redhat.com, rth@twiddle.net,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201204145152.097bb217.pasic@linux.ibm.com>
In-Reply-To: <20201204132500.GI3056135@redhat.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
        <20201204140205.66e205da.cohuck@redhat.com>
        <20201204130727.GD2883@work-vm>
        <20201204132500.GI3056135@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_04:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1011 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 13:25:00 +0000
Daniel P. Berrangé <berrange@redhat.com> wrote:

> On Fri, Dec 04, 2020 at 01:07:27PM +0000, Dr. David Alan Gilbert wrote:
> > * Cornelia Huck (cohuck@redhat.com) wrote:
> > > On Fri, 4 Dec 2020 09:06:50 +0100
> > > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > > 
> > > > On 04.12.20 06:44, David Gibson wrote:
> > > > > A number of hardware platforms are implementing mechanisms whereby the
> > > > > hypervisor does not have unfettered access to guest memory, in order
> > > > > to mitigate the security impact of a compromised hypervisor.
> > > > > 
> > > > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > > > to accomplish this in a different way, using a new memory protection
> > > > > level plus a small trusted ultravisor.  s390 also has a protected
> > > > > execution environment.
> > > > > 
> > > > > The current code (committed or draft) for these features has each
> > > > > platform's version configured entirely differently.  That doesn't seem
> > > > > ideal for users, or particularly for management layers.
> > > > > 
> > > > > AMD SEV introduces a notionally generic machine option
> > > > > "machine-encryption", but it doesn't actually cover any cases other
> > > > > than SEV.
> > > > > 
> > > > > This series is a proposal to at least partially unify configuration
> > > > > for these mechanisms, by renaming and generalizing AMD's
> > > > > "memory-encryption" property.  It is replaced by a
> > > > > "securable-guest-memory" property pointing to a platform specific  
> > > > 
> > > > Can we do "securable-guest" ?
> > > > s390x also protects registers and integrity. memory is only one piece
> > > > of the puzzle and what we protect might differ from platform to 
> > > > platform.
> > > > 
> > > 
> > > I agree. Even technologies that currently only do memory encryption may
> > > be enhanced with more protections later.
> > 
> > There's already SEV-ES patches onlist for this on the SEV side.
> > 
> > <sigh on haggling over the name>
> > 
> > Perhaps 'confidential guest' is actually what we need, since the
> > marketing folks seem to have started labelling this whole idea
> > 'confidential computing'.
> 
> I think we shouldn't worry about the specific name too much, as it
> won't be visible much outside QEMU and the internals of the immediate
> layer above such as libvirt. What matters much more is that we have
> documentation that clearly explains what the different levels of
> protection are for each different architecture, and/or generation of
> architecture. Mgmt apps / end users need understand exactly what
> kind of unicorns they are being promised for a given configuration.
> 
>

You are probably right, but I still prefer descriptive names over
misleading ones -- it helps with my cognitive process.

Regards,
Halil
