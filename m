Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758E71EF5CA
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgFEKwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 06:52:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726507AbgFEKwm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 06:52:42 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055AWbWs140100;
        Fri, 5 Jun 2020 06:52:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31fhr9nk8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 06:52:36 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055AZ10n148493;
        Fri, 5 Jun 2020 06:52:36 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31fhr9nk86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 06:52:36 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055Ap4Dg031721;
        Fri, 5 Jun 2020 10:52:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 31end6h9ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 10:52:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055AqVia64159896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 10:52:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD9934203F;
        Fri,  5 Jun 2020 10:52:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D3014204B;
        Fri,  5 Jun 2020 10:52:31 +0000 (GMT)
Received: from osiris (unknown [9.171.91.28])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  5 Jun 2020 10:52:31 +0000 (GMT)
Date:   Fri, 5 Jun 2020 12:52:30 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] s390/virtio: remove unused pm callbacks
Message-ID: <20200605105230.GA4189@osiris>
References: <20200526093629.257649-1-cohuck@redhat.com>
 <20200604234421.4ada966b.pasic@linux.ibm.com>
 <20200605093907.4d4b3c2a.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605093907.4d4b3c2a.cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_02:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 suspectscore=1
 lowpriorityscore=0 cotscore=-2147483648 impostorscore=0 spamscore=0
 clxscore=1011 phishscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 05, 2020 at 09:39:07AM +0200, Cornelia Huck wrote:
> On Thu, 4 Jun 2020 23:44:21 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > On Tue, 26 May 2020 11:36:29 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > > Support for hibernation on s390 has been recently been removed with
> 
> s/been recently been removed/recently been removed/
> 
> > > commit 394216275c7d ("s390: remove broken hibernate / power management
> > > support"), no need to keep unused code around.
> > > 
> > > Signed-off-by: Cornelia Huck <cohuck@redhat.com>  
> > 
> > Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> 
> Thanks!
> 
> As this is only a single patch, I think a pull request is a bit
> overkill, so it would probably be best for someone to pick this
> directly.
> 
> s390 arch maintainers? Michael?

Applied, thanks!
