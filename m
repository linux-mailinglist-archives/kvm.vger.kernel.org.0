Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41DB4AC392
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 16:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349972AbiBGPbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 10:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376744AbiBGPTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:19:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6096C0401C1;
        Mon,  7 Feb 2022 07:19:48 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217F5nvg003653;
        Mon, 7 Feb 2022 15:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ce6wOVruo9bxswsAKOFe1ZmHBS/57n/eWuo6M6ErD/g=;
 b=HN7jY/vMR/n39qTnOmLvEeBnK6rHcyblHPgSzm8qqsBOC5IO+yZqPRFdY21VpowKPKD1
 Yrug/U/5pNzC8bAaytWGp24JfBcaBT+cv/TVdjYugR79yoUbtWLl97FzaQbjWTO+sK1b
 a808Uoenhu4XixLElyxwgFZKbxjcMdffzV2OaaOvSclPqwep2pCD6cihlry25pW8VroM
 X7vG5Lx4o57ZLi8PuszjFopfjTs5InhWNcnPdE43qyoWGrPY01fA71ZolJ8/NTZ/4ycw
 S7nHd8XgAgOjIk6nOsKtiSpl6i2jRhEMSLUrdbhKr+qgK4iwGWLYbt64msVFA4pLMaP0 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qeqdgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:19:48 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217EfunU026961;
        Mon, 7 Feb 2022 15:19:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qeqdfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:19:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217FE49C006770;
        Mon, 7 Feb 2022 15:19:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gv9597g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:19:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217F9dLL49480162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 15:09:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDFD64C040;
        Mon,  7 Feb 2022 15:19:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FC924C052;
        Mon,  7 Feb 2022 15:19:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.12])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 15:19:41 +0000 (GMT)
Date:   Mon, 7 Feb 2022 16:19:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 16/17] KVM: s390: pv: add
 KVM_CAP_S390_PROT_REBOOT_ASYNC
Message-ID: <20220207161939.1d382a02@p-imbrenda>
In-Reply-To: <2b9b31bf-e45a-7006-c68e-6e143665640c@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
        <20220204155349.63238-17-imbrenda@linux.ibm.com>
        <2b9b31bf-e45a-7006-c68e-6e143665640c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1XzClqEa8wVZtHBTZ3aYPFVmKWq9aIcN
X-Proofpoint-GUID: KxN7VS6q_3bWEF7bOb-n9k-zUlZEC_1u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
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

On Mon, 7 Feb 2022 15:37:48 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/4/22 16:53, Claudio Imbrenda wrote:
> > Add KVM_CAP_S390_PROT_REBOOT_ASYNC to signal that the
> > KVM_PV_ASYNC_DISABLE and KVM_PV_ASYNC_DISABLE_PREPARE commands for the
> > KVM_S390_PV_COMMAND ioctl are available.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/kvm/kvm-s390.c | 3 +++
> >   include/uapi/linux/kvm.h | 1 +
> >   2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index f7952cef1309..1e696202a569 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -608,6 +608,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   	case KVM_CAP_S390_BPB:
> >   		r = test_facility(82);
> >   		break;
> > +	case KVM_CAP_S390_PROT_REBOOT_ASYNC:
> > +		r = lazy_destroy && is_prot_virt_host();  
> 
> While reboot might be the best use-case for the async disable I don't 
> think we should name the capability this way.
> 
> KVM_CAP_S390_PROTECTED_ASYNC_DESTR ?

then maybe 

KVM_CAP_S390_PROTECTED_ASYNC_DISABLE ?

> 
> It's a bit long but the initial capability didn't abbreviate the 
> protected part so it is what it is.
> 
> 
> > +		break;
> >   	case KVM_CAP_S390_PROTECTED:
> >   		r = is_prot_virt_host();
> >   		break;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 7f574c87a6ba..c41c108f6b14 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_VM_GPA_BITS 207
> >   #define KVM_CAP_XSAVE2 208
> >   #define KVM_CAP_SYS_ATTRIBUTES 209
> > +#define KVM_CAP_S390_PROT_REBOOT_ASYNC 215
> >   
> >   #ifdef KVM_CAP_IRQ_ROUTING
> >   
> >   
> 

