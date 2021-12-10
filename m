Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000DA46FCCF
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 09:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbhLJIkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 03:40:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232663AbhLJIkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 03:40:12 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA6wkPR040266;
        Fri, 10 Dec 2021 08:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=FJ2WBO1seFaD3EU10SvBw7CNtQkrcZB2rnVjxCeLqfM=;
 b=nao+kDG5ZdrSVf74uxjJu6mCzGLh+uajSFXLNsq5QhYFXRmLRnixF3b5doXoEh/EJEmT
 4XSFTB+F3zuNL0VAaNz/id//JH5m8nOFqysiL8CfvMU/aJG65c0vqwEa91AspbRNIK2w
 pAc1krGN/2GYndxFmBRwONl/ELmTMtKzLreZgJwMZHK1vK2vCCquy/vKKB0qZej3rOIm
 H9Xj1KuExFejahmvf7YuM8UG27cNfMtO745ZEAA1mk3KKzVDnw32anEwbD6WQ1wo0XZe
 m7S+pwetMqsW4indg2oakgXjcSBWKWbO4ChxkEYIm9KjGei1oRlXG62n0ShNHH5Zl8qZ Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv23nhrty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 08:36:37 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BA7Rgpl021771;
        Fri, 10 Dec 2021 08:36:37 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv23nhrss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 08:36:37 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BA8S65c011156;
        Fri, 10 Dec 2021 08:36:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3cqykget2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 08:36:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BA8aV4g27591064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 08:36:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D772A4054;
        Fri, 10 Dec 2021 08:36:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC182A4067;
        Fri, 10 Dec 2021 08:36:29 +0000 (GMT)
Received: from sig-9-145-163-175.de.ibm.com (unknown [9.145.163.175])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 08:36:29 +0000 (GMT)
Message-ID: <d08ddd8008468dddb02876c38313c17e57be89af.camel@linux.ibm.com>
Subject: Re: [PATCH 14/32] KVM: s390: pci: do initial setup for AEN
 interpretation
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Dec 2021 09:36:29 +0100
In-Reply-To: <31980a07-e2e8-cef3-f0b4-370dad4cb14c@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-15-mjrosato@linux.ibm.com>
         <596857e3-ab13-7513-eeda-ed407fe22732@linux.ibm.com>
         <31980a07-e2e8-cef3-f0b4-370dad4cb14c@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: toWC4W74o5bzcLAcc3TR0xGgU_7EsKtc
X-Proofpoint-GUID: 5qo78H_0h78S6eR4H29CDSe9yDRDJF7C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 15:20 -0500, Matthew Rosato wrote:
> On 12/9/21 2:54 PM, Christian Borntraeger wrote:
> > Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> > > Initial setup for Adapter Event Notification Interpretation for zPCI
> > > passthrough devices.  Specifically, allocate a structure for 
> > > forwarding of
> > > adapter events and pass the address of this structure to firmware.
> > > 
> > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > ---
> > >   arch/s390/include/asm/pci_insn.h |  12 ++++
> > >   arch/s390/kvm/interrupt.c        |  17 +++++
> > >   arch/s390/kvm/kvm-s390.c         |   3 +
> > >   arch/s390/kvm/pci.c              | 113 +++++++++++++++++++++++++++++++
> > >   arch/s390/kvm/pci.h              |  42 ++++++++++++
> > >   5 files changed, 187 insertions(+)
> > >   create mode 100644 arch/s390/kvm/pci.h
> > > 
---8<---
> > >   int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
> > >   {
> > > @@ -55,3 +162,9 @@ int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, 
> > > struct kvm *kvm)
> > >       return 0;
> > >   }
> > >   EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
> > > +
> > > +void kvm_s390_pci_init(void)
> > > +{
> > > +    spin_lock_init(&aift.gait_lock);
> > > +    mutex_init(&aift.lock);
> > > +}
> > 
> > Can we maybe use designated initializer for the static definition of 
> > aift, e.g. something
> > like
> > static struct zpci_aift aift = {
> >      .gait_lock = __SPIN_LOCK_UNLOCKED(aift.gait_lock),
> >      .lock    = __MUTEX_INITIALIZER(aift.lock),
> > }
> > and get rid of the init function? >
> 
> Maybe -- I can certainly do the above, but I do add a call to 
> zpci_get_mdd() in the init function (patch 23), so if I want to in patch 
> 23 instead add .mdd = zpci_get_mdd() to this designated initializer I'd 
> have to re-work zpci_get_mdd (patch 12) to return the mdd rather than 
> the CLP LIST PCI return code.  We want at least a warning if we're 
> setting a 0 for mdd because the CLP failed for some bizarre reason.
> 
> I guess one option would be to move the WARN_ON into the zpci_get_mdd() 
> function itself and then now we can do

Hmm, if we do change zpci_get_mdd() which I'm generally fine with I
feel like the initializer would be weird mix of truly static lock
initialization and a function that actually does a CLP.
I'm also a little worried about initialization order if kvm is built-
in. The CLP should work even with PCI not initialized but what if for
example the facility isn't even there?

Also if you do change zpci_get-mdd() I'd prefer a pr_err() instead of a
WARN_ON(), no reason to crash the system for this if it runs with
panic-on-warn. So I think overall keeping it as is makes more sense.

