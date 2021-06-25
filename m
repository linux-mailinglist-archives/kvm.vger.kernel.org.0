Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4473B417F
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFYKXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:23:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56106 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231433AbhFYKXp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 06:23:45 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PAAQ20021247;
        Fri, 25 Jun 2021 10:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=7a8ybzaKrAeCYOUXrDmQnWtnkWFb420VNKkKH/d1fjk=;
 b=sdUFCaacMV/Bqq9YOELwA0eY1gNdXXxWwaa97L+VE+rmF5b++d+yAXoNsh92yoLiOcSf
 LnRgY/GugSSqTPkWlZNpAMt9zvxn0YZ1IrAzidmny3mYw80Hs5YqqpNoPFY6xI55JKXf
 URfcSyZ/oKr4Za9Vw+jbmJ2TgfwHp4KRv9K6lLOKuhYLJvteFmas7qqVzp7c6sxmQEIR
 nvHrXvNBexmZufo0f+a8tQgoiOSBx9o2EdN97VAeKNushGDIcy/5cwyICrFnZx/ytf6L
 2BN7fkrkewwBk+EDrXSi+vs1PEoVdybXlnmOezpYaenHI1MSMciPRVnOR+f/4HNvbTdz +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39d27es1ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 10:21:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15PA9lgR012235;
        Fri, 25 Jun 2021 10:21:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 39d2py08vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 10:21:22 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15PAI0Pt036252;
        Fri, 25 Jun 2021 10:21:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 39d2py08uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 10:21:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15PALKmH020798;
        Fri, 25 Jun 2021 10:21:20 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Jun 2021 03:21:20 -0700
Date:   Fri, 25 Jun 2021 13:21:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     viremana@linux.microsoft.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: SVM: hyper-v: Enlightened MSR-Bitmap support
Message-ID: <YNWuGlKfZwZeN8CR@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: GWXPBTAyiAe85JTbiMyZbZ5Vy7e2FXTl
X-Proofpoint-ORIG-GUID: GWXPBTAyiAe85JTbiMyZbZ5Vy7e2FXTl
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Vineeth Pillai,

This is a semi-automatic email about new static checker warnings.

The patch c4327f15dfc7: "KVM: SVM: hyper-v: Enlightened MSR-Bitmap 
support" from Jun 3, 2021, leads to the following Smatch complaint:

    arch/x86/kvm/svm/svm_onhyperv.h:92 svm_hv_vmcb_dirty_nested_enlightenments()
    warn: variable dereferenced before check 'vmcb' (see line 84)

arch/x86/kvm/svm/svm_onhyperv.h
    83		struct hv_enlightenments *hve =
    84			(struct hv_enlightenments *)vmcb->control.reserved_sw;
                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^
Dereferenced

    85	
    86		/*
    87		 * vmcb can be NULL if called during early vcpu init.
                   ^^^^^^^^^^^^^^^^
Probably shouldn't be Dereferenced

    88		 * And its okay not to mark vmcb dirty during vcpu init
    89		 * as we mark it dirty unconditionally towards end of vcpu
    90		 * init phase.
    91		 */
    92		if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
                    ^^^^

    93		    hve->hv_enlightenments_control.msr_bitmap)
    94			vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);

regards,
dan carpenter
