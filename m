Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E5F321
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 11:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfD3Jh1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 30 Apr 2019 05:37:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726012AbfD3Jh1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Apr 2019 05:37:27 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3U9SvX4061838
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 05:37:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s6k4ha99k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 05:37:25 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 30 Apr 2019 10:37:24 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 10:37:22 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3U9bKEm32702580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 09:37:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CC394204F;
        Tue, 30 Apr 2019 09:37:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAEF342042;
        Tue, 30 Apr 2019 09:37:19 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.116])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Apr 2019 09:37:19 +0000 (GMT)
Date:   Tue, 30 Apr 2019 11:37:18 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v7 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
In-Reply-To: <efa8840b-35b1-2823-697f-ab56d4898854@linux.ibm.com>
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
        <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
        <20190429185002.6041eecc.pasic@linux.ibm.com>
        <14453f04-f13f-f63c-fd8a-d9d8834182e0@linux.ibm.com>
        <efa8840b-35b1-2823-697f-ab56d4898854@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 19043009-4275-0000-0000-0000032FDA31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043009-4276-0000-0000-0000383F323E
Message-Id: <20190430113718.426392f0.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=629 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Apr 2019 10:32:52 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> >>> +    aqic_gisa.gisa = gisa->next_alert >> 4;  
> >>
> >> Why gisa->next_alert? Isn't this supposed to get set to gisa origin
> >> (without some bits on the left)?  

s/left/right/

> > 
> > Someone already asked this question.

It must have been in some previous iteration... Can you give me a
pointer?

> > The answer is: look at the ap_qirq_ctrl structure, you will see that the 
> > gisa field is 27 bits wide.

My question was not about the width, but about gisa->next_alert being
used.

Regards,
Halil

