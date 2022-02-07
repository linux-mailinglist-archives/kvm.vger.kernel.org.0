Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557C14AC3AB
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 16:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384447AbiBGPcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 10:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbiBGPRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:17:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25919C0401C1;
        Mon,  7 Feb 2022 07:17:29 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217ElLlS019422;
        Mon, 7 Feb 2022 15:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tEgepnJEoQZ4iXRSDC1w82g+P2Pu53hAbz75cztooGE=;
 b=np5+/zw2ltxWtk20AamoleGK61DDKFy/LOA7UVfpPLVk6vi9HZK4MLbiwSXu7V8O+5ng
 9bkF7+wzwXHyQovIIx3zfqInTp5fYyd3V57Gn0XLi9FKABSe4nrPDuv815avkzlJN2c5
 RND54OAcghiS9s/ir5cuN0k6xA+Gjq0Nhkt53xPwYhZSFkI6Nd4Ku+NKxPicOeTNEjTv
 tIKnBMkZq5ZunfhKQ/MpvBjZUTm7AgJ0y62wj7nxZPlB+9CqfNW3Vh+lJuzHXZ7/ARlV
 h/VPVAwd6EU4dBUL+KfffeuyFvcy5hQ1vUYsPyG30aYesxCnS6+8aCYWoZ6hmo/PrTBI QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23anxed3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:17:28 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217FAw9f002352;
        Mon, 7 Feb 2022 15:17:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23anxecb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:17:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217FE1gW025192;
        Mon, 7 Feb 2022 15:17:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjp4v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:17:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217FHMeQ42795326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 15:17:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5CD611C05B;
        Mon,  7 Feb 2022 15:17:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B85311C06C;
        Mon,  7 Feb 2022 15:17:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.12])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 15:17:22 +0000 (GMT)
Date:   Mon, 7 Feb 2022 16:17:19 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 15/17] KVM: s390: pv: api documentation for
 asynchronous destroy
Message-ID: <20220207161719.5147058a@p-imbrenda>
In-Reply-To: <99296cad-5f74-d9ab-544c-b2d1a557b226@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
        <20220204155349.63238-16-imbrenda@linux.ibm.com>
        <99296cad-5f74-d9ab-544c-b2d1a557b226@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uoy9FUPqo5c_CZpBwDy5c5ljBNNZ8J8w
X-Proofpoint-ORIG-GUID: lSRehOmcpV7HKhU42zGzcYsX14s-Xwou
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Feb 2022 15:52:37 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/4/22 16:53, Claudio Imbrenda wrote:
> > Add documentation for the new commands added to the KVM_S390_PV_COMMAND
> > ioctl.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   Documentation/virt/kvm/api.rst | 21 ++++++++++++++++++---
> >   1 file changed, 18 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index a4267104db50..3b9068aceead 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -5010,11 +5010,13 @@ KVM_PV_ENABLE
> >     =====      =============================
> >   
> >   KVM_PV_DISABLE
> > -
> >     Deregister the VM from the Ultravisor and reclaim the memory that
> >     had been donated to the Ultravisor, making it usable by the kernel
> > -  again.  All registered VCPUs are converted back to non-protected
> > -  ones.
> > +  again. All registered VCPUs are converted back to non-protected
> > +  ones. If a previous VM had been prepared for asynchonous teardown
> > +  with KVM_PV_ASYNC_DISABLE_PREPARE and not actually torn down with
> > +  KVM_PV_ASYNC_DISABLE, it will be torn down in this call together with
> > +  the current VM.
> >   
> >   KVM_PV_VM_SET_SEC_PARMS
> >     Pass the image header from VM memory to the Ultravisor in
> > @@ -5027,6 +5029,19 @@ KVM_PV_VM_VERIFY
> >     Verify the integrity of the unpacked image. Only if this succeeds,
> >     KVM is allowed to start protected VCPUs.
> >   
> > +KVM_PV_ASYNC_DISABLE_PREPARE
> > +  Prepare the current protected VM for asynchronous teardown. The current  
> 
> I think the first sentence needs a few more examples of what we do so 
> the second sentence makes more sense.
> 
> ...by setting aside the pointers to the donated storage, replacing the 
> top most page table, destroying the first 2GB of memory and zeroing the 
> KVM PV structs.

I'm not sure we should give out implementation details, which might
change with newer kernel and/or hardware versions

> 
> 
> Or something which sounds a bit nicer.
> 
> > +  VM will then continue immediately as non-protected. If a protected VM had
> > +  already been set aside without starting the teardown process, this call
> > +  will fail. In this case the userspace process should issue a normal
> > +  KVM_PV_DISABLE.
> > +
> > +KVM_PV_ASYNC_DISABLE
> > +  Tear down the protected VM previously set aside for asynchronous teardown.
> > +  This PV command should ideally be issued by userspace from a separate
> > +  thread. If a fatal signal is received (or the process terminates
> > +  naturally), the command will terminate immediately without completing.
> > +
> >   4.126 KVM_X86_SET_MSR_FILTER
> >   ----------------------------
> >   
> >   
> 

