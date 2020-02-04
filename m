Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFD0151A83
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgBDMaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:30:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727199AbgBDMaN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 07:30:13 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014CU124010791
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 07:30:12 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxtbjp8th-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 07:30:12 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 4 Feb 2020 12:30:09 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 12:30:06 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014CU4YO24248722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 12:30:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 902DBAE051;
        Tue,  4 Feb 2020 12:30:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 411B7AE045;
        Tue,  4 Feb 2020 12:30:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 12:30:04 +0000 (GMT)
Date:   Tue, 4 Feb 2020 13:30:02 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 07/37] KVM: s390: add new variants of UV CALL
In-Reply-To: <20200204131107.6c7b3dae.cohuck@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-8-borntraeger@de.ibm.com>
        <20200204131107.6c7b3dae.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020412-0012-0000-0000-0000038391F9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020412-0013-0000-0000-000021BFF8CE
Message-Id: <20200204133002.5ddf78fd@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_03:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 13:11:07 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

[...]

> 
> > +	rc = uv_call_sched(0, (u64)&uvcb);
> > +	if (ret)
> > +		*ret = *(u32 *)&uvcb.header.rc;  
> 
> Does that rc value in the block contain anything sensible if you
> didn't get cc==0?

yes, RC is always meaningful. 

CC == 0 implies RC == 1, which means success.
CC == 1 implies RC != 1, which means something went wrong in some way

in theory you could always disregard CC and only check RC



Claudio

