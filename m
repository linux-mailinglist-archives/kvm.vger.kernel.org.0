Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8147A139597
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 17:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAMQRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 11:17:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726943AbgAMQRY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 11:17:24 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DGHDqr083480
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 11:17:23 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfvsyjp9b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 11:17:22 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Mon, 13 Jan 2020 16:17:20 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 Jan 2020 16:17:18 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00DGHHPe48038070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 16:17:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B70F52052;
        Mon, 13 Jan 2020 16:17:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D3B4452051;
        Mon, 13 Jan 2020 16:17:16 +0000 (GMT)
Date:   Mon, 13 Jan 2020 17:17:15 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v7 4/4] s390x: SCLP unit test
In-Reply-To: <9f0bee07-28bc-8154-3c67-402c82da8f89@redhat.com>
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
        <20200110184050.191506-5-imbrenda@linux.ibm.com>
        <8d7fb5c4-9e2c-e28a-16c0-658afcc8178d@redhat.com>
        <20200113133325.417bf657@p-imbrenda>
        <1b86b00a-261e-3d8c-fa52-c30e67463ad5@redhat.com>
        <20200113135832.1c6d3bb8@p-imbrenda>
        <22b5ce6a-18af-edec-efc6-e03450faddf8@redhat.com>
        <20200113150504.3fd218d5@p-imbrenda>
        <3db7eaf7-6020-365b-c849-9961e483352e@redhat.com>
        <20200113162439.7ae81f84@p-imbrenda>
        <9f0bee07-28bc-8154-3c67-402c82da8f89@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20011316-0020-0000-0000-000003A04D61
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011316-0021-0000-0000-000021F7BD9D
Message-Id: <20200113171715.7334c1be@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_05:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxlogscore=872 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jan 2020 17:06:05 +0100
David Hildenbrand <david@redhat.com> wrote:

[...]

> >>> this would be solved by adding special logic to the pgm interrupt
> >>> handler (as we have discussed in your previous email)
> >>>     
> >>
> >> I see, so the issue should hold for all SCLP checks where we don't
> >> expect an exception ... hmmm  
> >  
> > which is why my wrapper in the unit test is so complicated :)
> >   
> 
> so .... if we would implement my suggestion (if we get an exception
> on a servc instruction, clear sclp_busy) that code would get
> simplified as well? :)

sure, as I said, that can be done. The question is if we really want to
change something in the interrupt handler (shared by all s390x unit
tests) just for the benefit of this one unit test.

Also consider that the changes to the interrupt handler would not
necessarily be trivial. i.e. you need to check that the origin of the
pgm interrupt is a SERVC instruction, and then act accordingly.

