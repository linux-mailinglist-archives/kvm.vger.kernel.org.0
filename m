Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E048EA2F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbiANMzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:55:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235721AbiANMzk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 07:55:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECRVsu026589;
        Fri, 14 Jan 2022 12:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=s4D6B1FENGTeYDjbSfhWU4NJGrujzP5e+fx0FJoNjLQ=;
 b=VpWruDU4D/yD0rikbmNODrOLejU9VBO6XHaxlLeuG0Pddmwr65T6cOrj4KVXIzqlAD22
 HAtMnsPKmuP0OfEN2UZNnEOMijYRqMzwibbm5RbaKDc6gSqQ+8Jd+4MN7JIGxqTcO4d3
 Sz3aTK+/mP+65cSjP/Ssr9gu6e0/Y7uEcZoQ6MgZqcZK+Vb1/SKEj4GBqfDKjgpNN6CM
 BrBH8H48sWbKCtgbWAciKkFMC9/gGtQK3TrOVWlgZazMEIfEGqk9z+CxI73mMYp7OE7p
 zxywmOTJmPPhtaS5dTN7oyozjCeKtn7FXVR6AhLWhARb/fe7d6+WD3KXPTiwn5w/VVVD 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk96ugfdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:55:39 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EComVs029209;
        Fri, 14 Jan 2022 12:55:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk96ugfcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:55:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECqtKO001635;
        Fri, 14 Jan 2022 12:55:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjxkrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:55:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ECtX7v38666540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 12:55:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7292B5204F;
        Fri, 14 Jan 2022 12:55:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 096AE52050;
        Fri, 14 Jan 2022 12:55:32 +0000 (GMT)
Date:   Fri, 14 Jan 2022 13:55:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm
 queries
Message-ID: <20220114135530.749a7c6c@p-imbrenda>
In-Reply-To: <380e04e5-b487-36cf-a6f2-143b01c070ff@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-2-frankja@linux.ibm.com>
        <20220114121830.0f6c4908@p-imbrenda>
        <380e04e5-b487-36cf-a6f2-143b01c070ff@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4CKU0_DeXZ0Jd_xa2IVKwCSUP-G5AO5S
X-Proofpoint-ORIG-GUID: MqzqAguZpweCafVSjWSZ5Ewify8w-PfS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 13:28:19 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/14/22 12:18, Claudio Imbrenda wrote:
> > On Fri, 14 Jan 2022 10:02:41 +0000
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> This patch will likely (in parts) be replaced by Pierre's patch from
> >> his topology test series.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>  
> > 
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > 
> > although I think there is some room for improvement, but nothing too
> > serious, I'll probably fix it myself later  
> 
> I think I should add this to clean up the checks in the following patches:
> 
> bool vm_is_qemu(void)
> {
> 	return vm_is_kvm() || vm_is_tcg();
> }
> 
> That of course also isn't a 100% correct, we could have KVM + non-QEMU 
> but I'll cross that bridge when I get there.
> 
> And as I already mentioned in Pierre's patch, the STSI values are a bit 
> of a mystery to me since AFAIK we store KVM/Linux even if we run under TCG.

I was actually thinking of a generic detection function that will call
STSI only once and set all the necessary flags. 

then the various vm_is_* functions can become something like this:

bool vm_is_${TYPE}()
{
	if (vm_type == VM_TYPE_NOT_INITIALIZED)
		do_vm_detection();
	return vm_type == VM_${TYPE};
}

and then have all the magic hidden in the one do_vm_detection, which
will call STSI once and try to find out what we are running on.

