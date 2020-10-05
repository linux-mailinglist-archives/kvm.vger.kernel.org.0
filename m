Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC212830A1
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 09:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgJEHKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 03:10:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgJEHKc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 03:10:32 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09572GHO111488
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 03:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8WL9a98mDAYPlh4REpdIuJzraAnwQmfpKPmLNY9Wd6k=;
 b=WOXTEb6pFNJVMBKt7ggfO0T7EZ0SzFEyXUB2D8s0qCnUDr9ecmQcxdaYD7iw/YjfeFVu
 EWrfSkDQn0yP6bWmu30thdSrJNqi/rhma1nzWVgxROCdMcVcbpYN4ywycp0nXQg50yxo
 bQlFcF6frecCghiXPdpilxrCqSRslZ5GCdU+O2CnWxEJbEbBLqrxh1GsREXDxd1YKuZI
 Zw4mIAx7MF51bAj5ZzlZY42ENnS5aKRZ/KQGA1Fs8aq9c0MFqdicjcND1f0Erkm3j6d4
 prDFq+6VRcbZ24Mchf4l5psLKPv3Mrx0uGOJacD0fcm4V4xvMm9OJIBiKx8rY/f7TwIN wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33yvpwka52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 03:10:30 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09572PKa112433
        for <kvm@vger.kernel.org>; Mon, 5 Oct 2020 03:10:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33yvpwka45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 03:10:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09577fnc022171;
        Mon, 5 Oct 2020 07:10:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 33xgx89vw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 07:10:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0957APbF26870156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 07:10:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE0D5204E;
        Mon,  5 Oct 2020 07:10:25 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.175])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F22C352057;
        Mon,  5 Oct 2020 07:10:24 +0000 (GMT)
Date:   Mon, 5 Oct 2020 08:57:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/7] lib/list: Add double linked list
 management functions
Message-ID: <20201005085727.1fa6fc41@ibm-vm>
In-Reply-To: <20201002181844.jknzoeyigdew26ek@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-2-imbrenda@linux.ibm.com>
        <20201002181844.jknzoeyigdew26ek@kamzik.brq.redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_04:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Oct 2020 20:18:44 +0200
Andrew Jones <drjones@redhat.com> wrote:

[...]
> 
> I think we should just copy the kernel's list_head much closer.

fair enough; I think I'll just throw away this patch and steal the
kernel's implementation
